# ERP System — Microservices Architecture
> Java · Go · Spring Boot · Kafka · Docker · Kubernetes  
> Personal Project | Fresher Backend Developer

---

## Project Summary

A production-grade **Enterprise Resource Planning (ERP) backend** built with a microservices architecture using **Java (Spring Boot)** and **Go (Gin)**. The system consists of 6 independent services communicating via REST APIs and Apache Kafka events. Each service owns its own database, following the **Database-per-Service** pattern. The entire system is containerized with Docker and orchestrated using Kubernetes, with a Jenkins CI/CD pipeline for automated builds and deployments.

---

## Architecture Overview

```
Client / Browser
      │
      ▼
┌─────────────────────────┐
│      API Gateway         │  ← Spring Cloud Gateway
│  Routing · JWT Filter    │
│  Rate Limiting · LB      │
└─────────────────────────┘
      │
      ├──────────┬──────────┬──────────┬──────────┬──────────┐
      ▼          ▼          ▼          ▼          ▼          ▼
┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌──────────────┐
│  Auth   │ │Employee │ │Inventory│ │ Payroll │ │ Report  │ │Notification  │
│Service  │ │Service  │ │Service  │ │Service  │ │Service  │ │Service (Go)  │
│JWT+Redis│ │Postgres │ │ MongoDB │ │  MySQL  │ │GraphQL  │ │Gin + Kafka   │
└─────────┘ └─────────┘ └─────────┘ └─────────┘ └─────────┘ └──────────────┘
      │          │          │          │
      └──────────┴──────────┴──────────┘
                      │
                      ▼
            ┌──────────────────┐
            │   Apache Kafka   │
            │ Event Bus / Queue│
            └──────────────────┘
                      │
                      ▼
            ┌──────────────────┐
            │Notification Svc  │
            │  (Kafka Consumer)│
            └──────────────────┘

Infrastructure:
┌──────────────┐  ┌──────────────┐  ┌──────────────┐
│Eureka Server │  │Config Server │  │    Redis      │
│  (Discovery) │  │(Centralized) │  │(Cache/Session)│
└──────────────┘  └──────────────┘  └──────────────┘
```

---

## Services

### 1. Auth Service
**Tech:** Spring Boot · Spring Security · JWT · Redis · PostgreSQL

**Purpose:** Handles user registration, login, token generation, and validation. Redis caches JWT tokens for fast validation without hitting the DB on every request.

#### Controllers
| Controller | Endpoint | Method | Description |
|---|---|---|---|
| `AuthController` | `/api/auth/register` | POST | Register new user |
| `AuthController` | `/api/auth/login` | POST | Login, returns JWT token |
| `AuthController` | `/api/auth/logout` | POST | Invalidates token in Redis |
| `AuthController` | `/api/auth/refresh` | POST | Refresh expired JWT token |
| `AuthController` | `/api/auth/validate` | GET | Validate token (used by Gateway) |

#### Key Classes
```
auth-service/
├── controller/
│   └── AuthController.java
├── service/
│   ├── AuthService.java
│   └── TokenService.java
├── security/
│   ├── JwtUtil.java
│   ├── JwtFilter.java
│   └── SecurityConfig.java
├── repository/
│   └── UserRepository.java
├── model/
│   └── User.java
└── dto/
    ├── LoginRequest.java
    ├── RegisterRequest.java
    └── AuthResponse.java
```

---

### 2. Employee Service
**Tech:** Spring Boot · Spring Data JPA · PostgreSQL · Redis

**Purpose:** Manages employee records — create, update, delete, and fetch employees. Redis caches frequently accessed employee data. Publishes Kafka events on employee creation.

#### Controllers
| Controller | Endpoint | Method | Description |
|---|---|---|---|
| `EmployeeController` | `/api/employees` | GET | Get all employees (paginated) |
| `EmployeeController` | `/api/employees/{id}` | GET | Get employee by ID |
| `EmployeeController` | `/api/employees` | POST | Create new employee |
| `EmployeeController` | `/api/employees/{id}` | PUT | Update employee details |
| `EmployeeController` | `/api/employees/{id}` | DELETE | Delete employee |
| `EmployeeController` | `/api/employees/department/{dept}` | GET | Get employees by department |

#### Key Classes
```
employee-service/
├── controller/
│   └── EmployeeController.java
├── service/
│   ├── EmployeeService.java
│   └── EmployeeCacheService.java
├── repository/
│   └── EmployeeRepository.java
├── kafka/
│   └── EmployeeEventProducer.java
├── model/
│   └── Employee.java
└── dto/
    ├── EmployeeRequest.java
    └── EmployeeResponse.java
```

---

### 3. Inventory Service
**Tech:** Spring Boot · Spring Data MongoDB · MongoDB · Redis

**Purpose:** Manages product and stock inventory. MongoDB stores flexible product data. Redis caches hot inventory items. Publishes stock-level events to Kafka.

#### Controllers
| Controller | Endpoint | Method | Description |
|---|---|---|---|
| `InventoryController` | `/api/inventory` | GET | Get all inventory items |
| `InventoryController` | `/api/inventory/{id}` | GET | Get item by ID |
| `InventoryController` | `/api/inventory` | POST | Add new inventory item |
| `InventoryController` | `/api/inventory/{id}` | PUT | Update inventory item |
| `InventoryController` | `/api/inventory/{id}` | DELETE | Delete inventory item |
| `InventoryController` | `/api/inventory/{id}/stock` | PATCH | Update stock quantity |
| `InventoryController` | `/api/inventory/low-stock` | GET | Get low stock items |

#### Key Classes
```
inventory-service/
├── controller/
│   └── InventoryController.java
├── service/
│   ├── InventoryService.java
│   └── InventoryCacheService.java
├── repository/
│   └── InventoryRepository.java
├── kafka/
│   └── InventoryEventProducer.java
├── model/
│   └── InventoryItem.java
└── dto/
    ├── InventoryRequest.java
    └── InventoryResponse.java
```

---

### 4. Payroll Service
**Tech:** Spring Boot · Spring Data JPA · MySQL · Resilience4j

**Purpose:** Handles salary calculation and payroll records. Listens to Kafka employee-events to auto-create payroll entries when a new employee is added. Uses Resilience4j Circuit Breaker when calling Employee Service.

#### Controllers
| Controller | Endpoint | Method | Description |
|---|---|---|---|
| `PayrollController` | `/api/payroll` | GET | Get all payroll records |
| `PayrollController` | `/api/payroll/{id}` | GET | Get payroll by ID |
| `PayrollController` | `/api/payroll/employee/{empId}` | GET | Get payroll by employee |
| `PayrollController` | `/api/payroll` | POST | Create payroll record |
| `PayrollController` | `/api/payroll/{id}` | PUT | Update payroll |
| `PayrollController` | `/api/payroll/{id}/process` | POST | Process monthly payroll |

#### Key Classes
```
payroll-service/
├── controller/
│   └── PayrollController.java
├── service/
│   ├── PayrollService.java
│   └── SalaryCalculationService.java
├── repository/
│   └── PayrollRepository.java
├── kafka/
│   └── EmployeeEventConsumer.java
├── model/
│   └── Payroll.java
└── dto/
    ├── PayrollRequest.java
    └── PayrollResponse.java
```

---

### 5. Report Service
**Tech:** Spring Boot · GraphQL (`spring-boot-starter-graphql`) · PostgreSQL

**Purpose:** Provides a unified GraphQL API to query across employee, inventory, and payroll data. Clients can fetch exactly the fields they need in a single query — avoiding multiple REST calls.

#### GraphQL Schema
```graphql
type Query {
  employees(department: String, page: Int, size: Int): [Employee]
  employee(id: ID!): Employee
  inventoryItems(lowStock: Boolean): [InventoryItem]
  payrollByEmployee(employeeId: ID!): Payroll
  dashboardSummary: DashboardSummary
}

type Employee {
  id: ID
  name: String
  department: String
  email: String
  payroll: Payroll
}

type InventoryItem {
  id: ID
  name: String
  quantity: Int
  price: Float
}

type Payroll {
  id: ID
  employeeId: ID
  basicSalary: Float
  netSalary: Float
  month: String
}

type DashboardSummary {
  totalEmployees: Int
  totalInventoryItems: Int
  lowStockCount: Int
  totalPayrollAmount: Float
}
```

#### Controllers / Resolvers
| Type | Name | Description |
|---|---|---|
| `@QueryMapping` | `ReportController.employees()` | Fetch all employees via GraphQL |
| `@QueryMapping` | `ReportController.employee()` | Fetch single employee |
| `@QueryMapping` | `ReportController.inventoryItems()` | Fetch inventory |
| `@QueryMapping` | `ReportController.dashboardSummary()` | ERP dashboard stats |
| REST | `/api/reports/export` | Export report as JSON/CSV |

#### Key Classes
```
report-service/
├── controller/
│   └── ReportController.java        ← @QueryMapping (GraphQL)
├── service/
│   └── ReportService.java
├── client/
│   ├── EmployeeClient.java          ← Feign / RestTemplate
│   └── InventoryClient.java
└── dto/
    └── DashboardSummary.java
```

---

### 6. Notification Service (Go)
**Tech:** Go · Gin · Apache Kafka (Consumer) · Apache Commons Mail

**Purpose:** Consumes Kafka events from all services and sends email/system notifications. Built in Go to demonstrate polyglot microservices — shows Go + Gin alongside Java services.

#### Kafka Topics Consumed
| Topic | Trigger | Action |
|---|---|---|
| `employee-events` | New employee hired | Send welcome email |
| `employee-events` | Employee deleted | Send exit notification |
| `inventory-events` | Low stock alert | Send stock alert email |
| `payroll-events` | Payroll processed | Send payslip email |
| `auth-events` | Login from new device | Send security alert |

#### REST Endpoints (Gin Router)
| Endpoint | Method | Description |
|---|---|---|
| `/health` | GET | Health check |
| `/api/notify/email` | POST | Manually trigger email |
| `/api/notify/history` | GET | Get notification history |

#### Key Files
```
notification-service/           ← Go service
├── main.go
├── router/
│   └── router.go               ← Gin routes
├── handler/
│   └── notification_handler.go ← Gin controllers
├── kafka/
│   └── consumer.go             ← Kafka event consumer
├── email/
│   └── mailer.go               ← Email sending logic
└── model/
    └── notification.go
```

---

## Infrastructure Services

### Eureka Server (Service Discovery)
- All 6 microservices register as Eureka clients
- Services discover each other by name (not hardcoded URLs)
- Spring Cloud Netflix Eureka

### Config Server
- Centralized configuration for all services
- Git-backed YAML config files
- Services pull config on startup
- Covers: `application.yml`, `application-dev.yml`, `application-prod.yml`

### API Gateway (Spring Cloud Gateway)
- Single entry point for all client requests
- Routes traffic to correct microservice
- JWT validation filter — blocks unauthenticated requests
- Rate limiting per client IP
- Load balancing via Eureka

### Redis
- Auth Service: JWT token caching
- Employee Service: Employee data caching
- Inventory Service: Hot item caching
- Session management

---

## Kafka Topics & Event Flow

```
Employee Service  ──publishes──▶  employee-events  ──consumed by──▶  Notification Service
                                                   ──consumed by──▶  Payroll Service

Inventory Service ──publishes──▶  inventory-events ──consumed by──▶  Notification Service

Auth Service      ──publishes──▶  auth-events      ──consumed by──▶  Notification Service

Payroll Service   ──publishes──▶  payroll-events   ──consumed by──▶  Notification Service
```

---

## Resilience Patterns (Resilience4j)

| Pattern | Applied In | Purpose |
|---|---|---|
| Circuit Breaker | Payroll → Employee | Prevent cascade failure |
| Circuit Breaker | Report → Employee | Fallback if Employee down |
| Circuit Breaker | Report → Inventory | Fallback if Inventory down |
| Retry | All inter-service calls | Auto-retry on transient failures |
| Rate Limiter | API Gateway | Prevent DDoS / overload |

---

## Database Design

| Service | Database | Type | Reason |
|---|---|---|---|
| Auth Service | PostgreSQL | Relational | Structured user data, ACID |
| Employee Service | PostgreSQL | Relational | Structured HR data |
| Inventory Service | MongoDB | Document | Flexible product schema |
| Payroll Service | MySQL | Relational | Financial records, joins |
| Report Service | PostgreSQL | Relational | Query aggregation |
| Redis | Redis | In-Memory | Fast caching, token store |

---

## DevOps Setup

### Docker
- Each service has its own `Dockerfile`
- `docker-compose.yml` for local development
- Multi-stage builds to minimize image size

### Kubernetes
- `Deployment.yaml` per service
- `Service.yaml` for internal networking
- `ConfigMap` for environment config
- `Secret` for DB passwords and JWT keys

### Jenkins CI/CD Pipeline
```
Stage 1: Checkout    → Pull from Git
Stage 2: Build       → mvn clean install / go build
Stage 3: Test        → mvn test
Stage 4: Docker      → docker build & push to registry
Stage 5: Deploy      → kubectl apply
```

---

## API Documentation

- All Java services documented with **OpenAPI 3.0 / Swagger UI**
- Swagger UI available at `http://<service>:<port>/swagger-ui.html`
- Go Notification Service documented with inline comments

---

## Tech Stack Summary

| Category | Technologies |
|---|---|
| Languages | Java, Go |
| Frameworks | Spring Boot, Spring Security, Spring Data JPA, Gin |
| Databases | PostgreSQL, MySQL, MongoDB, Redis |
| Messaging | Apache Kafka |
| Service Mesh | Eureka, Spring Cloud Gateway, Config Server |
| Resilience | Resilience4j (Circuit Breaker, Retry, Rate Limiter) |
| API Styles | REST, GraphQL |
| DevOps | Docker, Kubernetes, Jenkins, Maven, Git |
| Documentation | OpenAPI, Swagger |
| Libraries | Apache Commons |
| Data Formats | JSON, XML, YAML |
| IDE | Zed |
| AI Assistants | Claude Code, Gemini CLI |

---

## Skills Demonstrated

- Microservices Design & Architecture
- Polyglot Programming (Java + Go)
- Event-Driven Architecture (Kafka)
- Secure API Design (JWT, Spring Security)
- Database-per-Service Pattern
- API Gateway & Service Discovery Pattern
- Circuit Breaker & Resilience Patterns
- GraphQL API Design
- Containerization & Orchestration (Docker + Kubernetes)
- CI/CD Pipeline (Jenkins)
- Centralized Configuration Management
- Caching Strategies (Redis)
- RESTful API Design & OpenAPI Documentation

---

*Project by: [Your Name] | GitHub: github.com/your-username/erp-microservices*
