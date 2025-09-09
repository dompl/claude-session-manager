# Node.js API Session Example

## Scenario

Building a RESTful API with Express.js, MongoDB, authentication, and implementing comprehensive security measures.

## Initial Session

### Project Setup

```bash
cd ~/projects/ecommerce-api
```

**Project structure:**

```
ecommerce-api/
├── package.json
├── server.js
├── routes/
├── models/
├── middleware/
├── controllers/
├── utils/
└── config/
```

### Claude CLI Session

```bash
claude code "help me implement comprehensive API security including rate limiting, input validation, and security headers"
```

**Session focus:**

- Rate limiting implementation
- Input validation with Joi
- Security headers with Helmet
- CORS configuration
- Error handling middleware
- API documentation setup

### Save Session

```bash
claude-save "API security hardening with rate limiting and comprehensive validation"
```

**Session details:**

- **Technology Stack**: Node.js, Express, MongoDB, Joi, Helmet, express-rate-limit
- **Problem**: Need production-ready security for ecommerce API
- **Claude's Help**: Complete security middleware stack implementation
- **Files Created**: Multiple middleware, validation schemas, security config
- **Next Steps**: Add API documentation with Swagger and implement logging

## Complete Conversation Example

### Session File Content

````markdown
# Claude Session: API security hardening with rate limiting and validation

**Project:** ecommerce-api  
**Date:** 2024-12-09  
**Session ID:** ecommerce-api-20241209-143022

## Context

**Technology Stack:** Node.js, Express, MongoDB, Joi, Helmet, JWT  
**Problem:** Implement production-ready security for ecommerce API  
**Claude's Help:** Comprehensive security middleware and validation system

## Complete Conversation

### Your Initial Request:

I have an ecommerce API that needs to be production-ready. I need rate limiting, proper input validation, security headers, and robust error handling. Can you help me implement these security measures?

### Claude's Security Analysis:

For a production ecommerce API, security is critical. I'll help you implement a comprehensive security stack including rate limiting, input validation, security headers, and proper error handling. Let's start with the middleware structure...

### Rate Limiting Implementation:

#### middleware/rateLimiter.js

```javascript
const rateLimit = require("express-rate-limit");
const RedisStore = require("rate-limit-redis");
const redis = require("redis");

// Create Redis client for rate limiting storage
const redisClient = redis.createClient({
	host: process.env.REDIS_HOST || "localhost",
	port: process.env.REDIS_PORT || 6379,
	password: process.env.REDIS_PASSWORD,
});

// General API rate limiting
const generalLimiter = rateLimit({
	store: new RedisStore({
		client: redisClient,
		prefix: "rl:general:",
	}),
	windowMs: 15 * 60 * 1000, // 15 minutes
	max: 100, // limit each IP to 100 requests per windowMs
	message: {
		error: "Too many requests from this IP, please try again later.",
		retryAfter: 15 * 60, // 15 minutes in seconds
	},
	standardHeaders: true,
	legacyHeaders: false,
	skip: (req) => {
		// Skip rate limiting for health checks
		return req.path === "/health";
	},
});

// Strict rate limiting for authentication endpoints
const authLimiter = rateLimit({
	store: new RedisStore({
		client: redisClient,
		prefix: "rl:auth:",
	}),
	windowMs: 15 * 60 * 1000, // 15 minutes
	max: 5, // limit each IP to 5 login attempts per 15 minutes
	message: {
		error: "Too many login attempts, please try again later.",
		retryAfter: 15 * 60,
	},
	standardHeaders: true,
	legacyHeaders: false,
	skipSuccessfulRequests: true, // Don't count successful logins
});

// Password reset rate limiting
const passwordResetLimiter = rateLimit({
	store: new RedisStore({
		client: redisClient,
		prefix: "rl:reset:",
	}),
	windowMs: 60 * 60 * 1000, // 1 hour
	max: 3, // limit each IP to 3 password reset requests per hour
	message: {
		error: "Too many password reset attempts, please try again later.",
		retryAfter: 60 * 60,
	},
});

module.exports = {
	generalLimiter,
	authLimiter,
	passwordResetLimiter,
};
```
````

### Input Validation System:

#### middleware/validation.js

```javascript
const Joi = require("joi");

// Custom validation schemas
const schemas = {
	// User registration validation
	userRegistration: Joi.object({
		email: Joi.string()
			.email({ minDomainSegments: 2, tlds: { allow: ["com", "net", "org"] } })
			.required()
			.messages({
				"string.email": "Please provide a valid email address",
				"any.required": "Email is required",
			}),

		password: Joi.string()
			.min(8)
			.pattern(new RegExp("^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#$%^&*])"))
			.required()
			.messages({
				"string.min": "Password must be at least 8 characters long",
				"string.pattern.base":
					"Password must contain at least one lowercase letter, one uppercase letter, one number, and one special character",
				"any.required": "Password is required",
			}),

		firstName: Joi.string()
			.min(2)
			.max(30)
			.pattern(/^[A-Za-z\s]+$/)
			.required()
			.messages({
				"string.min": "First name must be at least 2 characters",
				"string.max": "First name cannot exceed 30 characters",
				"string.pattern.base": "First name can only contain letters and spaces",
			}),

		lastName: Joi.string()
			.min(2)
			.max(30)
			.pattern(/^[A-Za-z\s]+$/)
			.required(),
	}),

	// Product creation validation
	productCreation: Joi.object({
		name: Joi.string().min(2).max(100).required(),
		description: Joi.string().max(1000).required(),
		price: Joi.number().positive().precision(2).required(),
		category: Joi.string().valid("electronics", "clothing", "books", "home").required(),
		inventory: Joi.number().integer().min(0).required(),
		images: Joi.array()
			.items(Joi.string().uri({ scheme: ["http", "https"] }))
			.max(5),
		tags: Joi.array().items(Joi.string().max(20)).max(10),
	}),

	// Order creation validation
	orderCreation: Joi.object({
		items: Joi.array()
			.items(
				Joi.object({
					productId: Joi.string().hex().length(24).required(),
					quantity: Joi.number().integer().min(1).max(100).required(),
				})
			)
			.min(1)
			.required(),

		shippingAddress: Joi.object({
			street: Joi.string().max(100).required(),
			city: Joi.string().max(50).required(),
			state: Joi.string().max(50).required(),
			zipCode: Joi.string()
				.pattern(/^\d{5}(-\d{4})?$/)
				.required(),
			country: Joi.string().max(50).required(),
		}).required(),
	}),
};

// Validation middleware factory
const validate = (schema) => {
	return (req, res, next) => {
		const { error, value } = schema.validate(req.body, {
			abortEarly: false, // Return all errors
			stripUnknown: true, // Remove unknown fields
		});

		if (error) {
			const errorMessages = error.details.map((detail) => ({
				field: detail.path.join("."),
				message: detail.message,
			}));

			return res.status(400).json({
				error: "Validation failed",
				details: errorMessages,
			});
		}

		// Replace req.body with validated and sanitized data
		req.body = value;
		next();
	};
};

module.exports = {
	schemas,
	validate,
};
```

### Security Headers Middleware:

#### middleware/security.js

```javascript
const helmet = require("helmet");
const cors = require("cors");

// CORS configuration
const corsOptions = {
	origin: function (origin, callback) {
		const allowedOrigins = process.env.ALLOWED_ORIGINS?.split(",") || [
			"http://localhost:3000",
			"http://localhost:3001",
		];

		// Allow requests with no origin (mobile apps, etc.)
		if (!origin) return callback(null, true);

		if (allowedOrigins.indexOf(origin) !== -1) {
			callback(null, true);
		} else {
			callback(new Error("Not allowed by CORS"));
		}
	},
	credentials: true, // Allow cookies
	methods: ["GET", "POST", "PUT", "DELETE", "PATCH", "OPTIONS"],
	allowedHeaders: ["Content-Type", "Authorization", "X-Requested-With"],
	maxAge: 86400, // 24 hours
};

// Security middleware setup
const setupSecurity = (app) => {
	// Basic security headers
	app.use(
		helmet({
			contentSecurityPolicy: {
				directives: {
					defaultSrc: ["'self'"],
					styleSrc: ["'self'", "'unsafe-inline'"],
					scriptSrc: ["'self'"],
					imgSrc: ["'self'", "data:", "https:"],
					connectSrc: ["'self'"],
					fontSrc: ["'self'"],
					objectSrc: ["'none'"],
					mediaSrc: ["'self'"],
					frameSrc: ["'none'"],
				},
			},
			crossOriginEmbedderPolicy: false,
		})
	);

	// CORS
	app.use(cors(corsOptions));

	// Custom security headers
	app.use((req, res, next) => {
		res.setHeader("X-API-Version", "1.0");
		res.setHeader("X-Response-Time", Date.now());
		next();
	});

	// Remove powered-by header
	app.disable("x-powered-by");
};

module.exports = {
	setupSecurity,
	corsOptions,
};
```

### Error Handling Middleware:

#### middleware/errorHandler.js

```javascript
const logger = require("../utils/logger");

// Custom error class
class APIError extends Error {
	constructor(message, statusCode = 500, isOperational = true) {
		super(message);
		this.statusCode = statusCode;
		this.isOperational = isOperational;
		this.timestamp = new Date().toISOString();

		Error.captureStackTrace(this, this.constructor);
	}
}

// 404 handler
const notFoundHandler = (req, res, next) => {
	const error = new APIError(`Route ${req.originalUrl} not found`, 404);
	next(error);
};

// Global error handler
const globalErrorHandler = (error, req, res, next) => {
	let { statusCode = 500, message, isOperational = false } = error;

	// Log error details
	logger.error({
		error: message,
		stack: error.stack,
		url: req.originalUrl,
		method: req.method,
		ip: req.ip,
		userAgent: req.get("User-Agent"),
		timestamp: new Date().toISOString(),
	});

	// Mongoose validation error
	if (error.name === "ValidationError") {
		const errors = Object.values(error.errors).map((err) => err.message);
		message = `Invalid input data: ${errors.join(", ")}`;
		statusCode = 400;
	}

	// Mongoose duplicate key error
	if (error.code === 11000) {
		const field = Object.keys(error.keyValue)[0];
		message = `Duplicate value for field: ${field}`;
		statusCode = 409;
	}

	// JWT errors
	if (error.name === "JsonWebTokenError") {
		message = "Invalid token";
		statusCode = 401;
	}

	if (error.name === "TokenExpiredError") {
		message = "Token expired";
		statusCode = 401;
	}

	// Development vs production error response
	const errorResponse = {
		error: message,
		status: statusCode,
		timestamp: new Date().toISOString(),
	};

	// Include stack trace in development
	if (process.env.NODE_ENV === "development") {
		errorResponse.stack = error.stack;
		errorResponse.details = error;
	}

	// Don't leak error details in production for non-operational errors
	if (process.env.NODE_ENV === "production" && !isOperational) {
		errorResponse.error = "Something went wrong";
	}

	res.status(statusCode).json(errorResponse);
};

module.exports = {
	APIError,
	notFoundHandler,
	globalErrorHandler,
};
```

### Main Server Integration:

#### server.js

```javascript
const express = require("express");
const mongoose = require("mongoose");
const { setupSecurity } = require("./middleware/security");
const { generalLimiter, authLimiter } = require("./middleware/rateLimiter");
const { notFoundHandler, globalErrorHandler } = require("./middleware/errorHandler");
const logger = require("./utils/logger");

const app = express();

// Trust proxy (important for rate limiting behind reverse proxy)
app.set("trust proxy", 1);

// Security middleware
setupSecurity(app);

// Body parsing middleware
app.use(express.json({ limit: "10mb" }));
app.use(express.urlencoded({ extended: true, limit: "10mb" }));

// General rate limiting
app.use(generalLimiter);

// Routes with specific rate limiting
app.use("/api/auth", authLimiter, require("./routes/auth"));
app.use("/api/users", require("./routes/users"));
app.use("/api/products", require("./routes/products"));
app.use("/api/orders", require("./routes/orders"));

// Health check endpoint (excluded from rate limiting)
app.get("/health", (req, res) => {
	res.status(200).json({
		status: "OK",
		timestamp: new Date().toISOString(),
		uptime: process.uptime(),
	});
});

// Error handling middleware (must be last)
app.use(notFoundHandler);
app.use(globalErrorHandler);

// Database connection
mongoose
	.connect(process.env.MONGODB_URI, {
		useNewUrlParser: true,
		useUnifiedTopology: true,
	})
	.then(() => logger.info("Connected to MongoDB"))
	.catch((err) => logger.error("MongoDB connection error:", err));

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
	logger.info(`Server running on port ${PORT}`);
});

module.exports = app;
```

### Security Best Practices Implemented:

1. **Multi-tier Rate Limiting**: Different limits for different endpoints
2. **Comprehensive Input Validation**: Joi schemas with detailed error messages
3. **Security Headers**: Helmet with CSP and custom headers
4. **CORS Configuration**: Whitelist approach with credential support
5. **Error Handling**: Secure error responses that don't leak sensitive info
6. **Logging**: Comprehensive request/error logging for monitoring

### Performance Considerations:

- Redis-based rate limiting for scalability
- Request body size limits
- Efficient validation with early abort options
- Trust proxy configuration for load balancers

### Next Steps Discussed:

1. Add Swagger/OpenAPI documentation
2. Implement comprehensive logging system
3. Set up monitoring and alerting
4. Add API versioning strategy
5. Implement caching layer with Redis

````

## Resume Session Later

### Two weeks later:
```bash
cd ~/projects/ecommerce-api
claude-resume
````

**Select the security session:**

```bash
claude code "Continue with the API security work. Now I need to add comprehensive API documentation with Swagger and implement the logging system we discussed."
```

### Claude's Context-Aware Response:

_"I remember we implemented a comprehensive security stack with rate limiting, input validation, security headers, and error handling for your ecommerce API. You wanted to add Swagger documentation and enhanced logging next. Let me help you integrate these with the existing security middleware..."_

Claude continues by:

- Adding Swagger/OpenAPI documentation that includes security schemes
- Implementing structured logging that integrates with the error handler
- Setting up request/response logging middleware
- Adding API versioning that works with existing rate limiting
- Maintaining consistency with established patterns

## Benefits Demonstrated

✅ **Security Architecture Memory**: Complete understanding of implemented security layers  
✅ **Middleware Integration**: Knows how components work together  
✅ **Configuration Context**: Remembers Redis, CORS, and validation setups  
✅ **Code Patterns**: Maintains consistent error handling and validation approaches  
✅ **Production Readiness**: Continues building enterprise-grade features

## Session Value for Complex APIs

This demonstrates how session restoration provides:

- **Security Context**: Understanding of implemented security measures
- **Architecture Continuity**: Building on established middleware patterns
- **Configuration Memory**: Redis, database, and environment setups
- **Integration Knowledge**: How different security layers work together
- **Next Phase Planning**: Seamless transition to documentation and monitoring
