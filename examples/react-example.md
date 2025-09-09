# React Project Session Example

## Scenario

Building a React dashboard application with user authentication, API integration, and complex state management.

## Initial Session

### Project Setup

```bash
cd ~/projects/react-dashboard
```

**Project structure:**

```
react-dashboard/
├── package.json
├── src/
│   ├── components/
│   ├── hooks/
│   ├── services/
│   ├── context/
│   └── pages/
├── public/
└── README.md
```

### Claude CLI Session

```bash
claude code "help me implement JWT authentication with protected routes and proper state management"
```

**Conversation focus:**

- JWT token storage strategies
- React Context for authentication state
- Protected route components
- API service layer setup
- Login/logout flow implementation

### Save Session

```bash
claude-save "JWT authentication setup with protected routes and Context API"
```

**Session context captured:**

- **Technology Stack**: React, JWT, Context API, React Router, Axios
- **Problem**: Need secure authentication system with protected routes
- **Claude's Help**: Complete auth architecture with best practices
- **Files Created**: AuthContext, ProtectedRoute, LoginForm, API service
- **Next Steps**: Add password reset and token refresh functionality

## Complete Conversation Example

### Session File Content

````markdown
# Claude Session: JWT authentication setup with protected routes

**Project:** react-dashboard  
**Date:** 2024-12-09  
**Session ID:** react-dashboard-20241209-143022

## Context

**Technology Stack:** React 18, JWT, Context API, React Router, Axios  
**Problem:** Implement secure user authentication with protected routes  
**Claude's Help:** Complete auth architecture with security best practices

## Complete Conversation

### Your Initial Request:

I need to implement user authentication in my React dashboard. I want to use JWT tokens, have protected routes, and manage auth state properly across the app.

### Claude's Analysis:

For a secure and maintainable authentication system, I recommend using React Context for state management and httpOnly cookies for token storage. Let me walk you through the complete implementation...

### Authentication Context Implementation:

#### AuthContext.js

```javascript
import React, { createContext, useContext, useReducer, useEffect } from "react";
import { authAPI } from "../services/authAPI";

const AuthContext = createContext();

const authReducer = (state, action) => {
	switch (action.type) {
		case "LOGIN_START":
			return { ...state, loading: true, error: null };
		case "LOGIN_SUCCESS":
			return {
				...state,
				loading: false,
				isAuthenticated: true,
				user: action.payload,
				error: null,
			};
		case "LOGIN_FAILURE":
			return {
				...state,
				loading: false,
				isAuthenticated: false,
				user: null,
				error: action.payload,
			};
		case "LOGOUT":
			return {
				...state,
				isAuthenticated: false,
				user: null,
				error: null,
			};
		case "TOKEN_REFRESH":
			return { ...state, user: action.payload };
		default:
			return state;
	}
};

const initialState = {
	isAuthenticated: false,
	user: null,
	loading: true,
	error: null,
};

export const AuthProvider = ({ children }) => {
	const [state, dispatch] = useReducer(authReducer, initialState);

	useEffect(() => {
		// Check if user is already authenticated on app load
		const checkAuthStatus = async () => {
			try {
				const user = await authAPI.getCurrentUser();
				dispatch({ type: "LOGIN_SUCCESS", payload: user });
			} catch (error) {
				dispatch({ type: "LOGIN_FAILURE", payload: "Not authenticated" });
			}
		};

		checkAuthStatus();
	}, []);

	const login = async (credentials) => {
		dispatch({ type: "LOGIN_START" });
		try {
			const response = await authAPI.login(credentials);
			dispatch({ type: "LOGIN_SUCCESS", payload: response.user });
			return response;
		} catch (error) {
			dispatch({ type: "LOGIN_FAILURE", payload: error.message });
			throw error;
		}
	};

	const logout = async () => {
		try {
			await authAPI.logout();
			dispatch({ type: "LOGOUT" });
		} catch (error) {
			// Even if logout fails on server, clear local state
			dispatch({ type: "LOGOUT" });
		}
	};

	const refreshToken = async () => {
		try {
			const user = await authAPI.refreshToken();
			dispatch({ type: "TOKEN_REFRESH", payload: user });
			return user;
		} catch (error) {
			dispatch({ type: "LOGOUT" });
			throw error;
		}
	};

	const value = {
		...state,
		login,
		logout,
		refreshToken,
	};

	return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>;
};

export const useAuth = () => {
	const context = useContext(AuthContext);
	if (!context) {
		throw new Error("useAuth must be used within an AuthProvider");
	}
	return context;
};
```
````

### Protected Route Component:

#### ProtectedRoute.js

```javascript
import React from "react";
import { Navigate, useLocation } from "react-router-dom";
import { useAuth } from "../context/AuthContext";
import LoadingSpinner from "./LoadingSpinner";

const ProtectedRoute = ({ children, requiredRole = null }) => {
	const { isAuthenticated, user, loading } = useAuth();
	const location = useLocation();

	if (loading) {
		return <LoadingSpinner />;
	}

	if (!isAuthenticated) {
		// Redirect to login with return path
		return <Navigate to="/login" state={{ from: location }} replace />;
	}

	// Check role-based access if required
	if (requiredRole && user?.role !== requiredRole) {
		return <Navigate to="/unauthorized" replace />;
	}

	return children;
};

export default ProtectedRoute;
```

### API Service Layer:

#### authAPI.js

```javascript
import axios from "axios";

const API_BASE_URL = process.env.REACT_APP_API_URL || "http://localhost:3001/api";

// Create axios instance with default config
const apiClient = axios.create({
	baseURL: API_BASE_URL,
	withCredentials: true, // Important for httpOnly cookies
	headers: {
		"Content-Type": "application/json",
	},
});

// Response interceptor for token refresh
apiClient.interceptors.response.use(
	(response) => response,
	async (error) => {
		const originalRequest = error.config;

		if (error.response?.status === 401 && !originalRequest._retry) {
			originalRequest._retry = true;

			try {
				await authAPI.refreshToken();
				return apiClient(originalRequest);
			} catch (refreshError) {
				// Refresh failed, redirect to login
				window.location.href = "/login";
				return Promise.reject(refreshError);
			}
		}

		return Promise.reject(error);
	}
);

export const authAPI = {
	login: async (credentials) => {
		const response = await apiClient.post("/auth/login", credentials);
		return response.data;
	},

	logout: async () => {
		const response = await apiClient.post("/auth/logout");
		return response.data;
	},

	getCurrentUser: async () => {
		const response = await apiClient.get("/auth/me");
		return response.data;
	},

	refreshToken: async () => {
		const response = await apiClient.post("/auth/refresh");
		return response.data;
	},

	register: async (userData) => {
		const response = await apiClient.post("/auth/register", userData);
		return response.data;
	},
};

export default apiClient;
```

### Login Form Component:

#### LoginForm.js

```javascript
import React, { useState } from "react";
import { useNavigate, useLocation } from "react-router-dom";
import { useAuth } from "../context/AuthContext";

const LoginForm = () => {
	const [formData, setFormData] = useState({
		email: "",
		password: "",
	});
	const { login, loading, error } = useAuth();
	const navigate = useNavigate();
	const location = useLocation();

	const from = location.state?.from?.pathname || "/dashboard";

	const handleSubmit = async (e) => {
		e.preventDefault();
		try {
			await login(formData);
			navigate(from, { replace: true });
		} catch (error) {
			// Error handling is managed by AuthContext
			console.error("Login failed:", error);
		}
	};

	const handleChange = (e) => {
		setFormData((prev) => ({
			...prev,
			[e.target.name]: e.target.value,
		}));
	};

	return (
		<div className="login-container">
			<form onSubmit={handleSubmit} className="login-form">
				<h2>Login to Dashboard</h2>

				{error && <div className="error-message">{error}</div>}

				<div className="form-group">
					<label htmlFor="email">Email:</label>
					<input
						type="email"
						id="email"
						name="email"
						value={formData.email}
						onChange={handleChange}
						required
						disabled={loading}
					/>
				</div>

				<div className="form-group">
					<label htmlFor="password">Password:</label>
					<input
						type="password"
						id="password"
						name="password"
						value={formData.password}
						onChange={handleChange}
						required
						disabled={loading}
					/>
				</div>

				<button type="submit" className="login-button" disabled={loading}>
					{loading ? "Logging in..." : "Login"}
				</button>
			</form>
		</div>
	);
};

export default LoginForm;
```

### App.js Integration:

```javascript
import React from "react";
import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
import { AuthProvider } from "./context/AuthContext";
import ProtectedRoute from "./components/ProtectedRoute";
import LoginForm from "./components/LoginForm";
import Dashboard from "./pages/Dashboard";
import Profile from "./pages/Profile";
import AdminPanel from "./pages/AdminPanel";

function App() {
	return (
		<AuthProvider>
			<Router>
				<Routes>
					<Route path="/login" element={<LoginForm />} />
					<Route
						path="/dashboard"
						element={
							<ProtectedRoute>
								<Dashboard />
							</ProtectedRoute>
						}
					/>
					<Route
						path="/profile"
						element={
							<ProtectedRoute>
								<Profile />
							</ProtectedRoute>
						}
					/>
					<Route
						path="/admin"
						element={
							<ProtectedRoute requiredRole="admin">
								<AdminPanel />
							</ProtectedRoute>
						}
					/>
					<Route path="/" element={<Navigate to="/dashboard" />} />
				</Routes>
			</Router>
		</AuthProvider>
	);
}

export default App;
```

### Security Considerations Discussed:

1. **httpOnly Cookies**: JWT stored in httpOnly cookies to prevent XSS
2. **Automatic Token Refresh**: Seamless token renewal with axios interceptors
3. **Role-based Access**: Protected routes with role checking
4. **Secure Logout**: Proper cleanup of authentication state
5. **Error Handling**: Comprehensive error states and user feedback

### Next Steps Identified:

1. Implement password reset functionality
2. Add "Remember Me" option
3. Set up email verification flow
4. Add social login options (Google, GitHub)
5. Implement user profile management

````

## Resume Session Later

### One week later:
```bash
cd ~/projects/react-dashboard
claude-resume
````

**Select the authentication session, then:**

```bash
claude code "Continue with our authentication system. I need to implement the password reset functionality we discussed."
```

### Claude's Context-Aware Response:

_"I remember we built a comprehensive JWT authentication system with React Context, protected routes, and httpOnly cookie storage. You wanted to add password reset functionality next. Let me help you implement that using the same patterns we established..."_

Claude continues with:

- Password reset request form
- Email verification flow
- Reset token validation
- New password submission
- Integration with existing auth system

## Benefits Demonstrated

✅ **Architecture Continuity**: Claude remembers the Context API patterns  
✅ **Code Consistency**: Uses same naming conventions and structure  
✅ **Security Context**: Remembers httpOnly cookie decision and reasoning  
✅ **Component Structure**: Understands the established file organization  
✅ **Next Phase**: Seamlessly continues with password reset implementation

## Session Value

This example shows how session restoration enables:

- **Complex System Memory**: Complete auth architecture understanding
- **Decision Context**: Why certain security approaches were chosen
- **Code Pattern Consistency**: Maintaining established conventions
- **Incremental Development**: Building on previous foundations
- **Long-term Project Continuity**: Weeks/months between sessions
