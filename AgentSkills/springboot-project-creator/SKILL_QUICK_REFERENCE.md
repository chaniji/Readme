# springboot-project-creator Skill - Quick Reference

## What This Skill Does

Generates **production-ready Spring Boot project scaffolds** that match your exact architectural patterns from your Employee Service.

## When to Use

- Creating a new Spring Boot microservice
- Starting a new project module
- Ensuring consistency across projects
- Onboarding new team members with proven patterns
- Scaffolding complex services quickly

## How to Invoke

Simply ask Claude:
```
@springboot-project-creator

I need a new Spring Boot service for [domain]. 
Service name: [name]
Package: [base.package]
Port: [port, default 8080]
```

## What You Get

✅ Complete Maven project structure  
✅ pom.xml with Spring Boot 4.0.3  
✅ application.yml pre-configured  
✅ GlobalExceptionHandler  
✅ Base DTOs (Request/Response)  
✅ Base Service layer  
✅ Base Controller with Swagger  
✅ Repository interface  
✅ 5+ documentation files  
✅ Ready-to-extend structure  

## Your Patterns Implemented

### 3-Tier Architecture
```
Controller → Service → Repository → Entity → Database
```

### DTO Separation
```
Request (validation) + Response (output) + Entity (persistence)
```

### Dependency Injection
```java
@Service
@RequiredArgsConstructor
public class UserService {
  private final UserRepository repo;  // Constructor injected
}
```

### Exception Handling
```java
@RestControllerAdvice
public class GlobalExceptionHandler {
  @ExceptionHandler(ResourceNotFoundException.class)
  public ErrorResponse handle(...) { ... }
}
```

## Required Info to Provide

1. **Project Name** - e.g., "invoice-service"
2. **Base Package** - e.g., "com.acme.billing"
3. **Description** - What the service does
4. **Port** - Server port (optional, default 8080)
5. **Database** - Name (optional, defaults to project name)

## Skill Location

```
/home/chan/.agents/skills/springboot-project-creator/
├── SKILL.md              (Full documentation)
└── evals/evals.json      (Test scenarios)
```

## Tech Stack Provided

- **Spring Boot:** 4.0.3 (or 3.2.0 LTS)
- **Java:** 21 (LTS)
- **Database:** PostgreSQL (with JPA/Hibernate)
- **Service Discovery:** Netflix Eureka
- **API Docs:** SpringDoc OpenAPI (Swagger)
- **Code Gen:** Lombok (@RequiredArgsConstructor, @Getter, @Setter)
- **Build:** Maven 3.8+
- **Validation:** Jakarta Bean Validation

## Package Structure Generated

```
com.acme.billing/
├── BillingServiceApplication.java
├── controller/
│   └── *Controller.java
├── service/
│   ├── *Service.java
│   └── impl/
│       └── *ServiceImpl.java
├── repository/
│   └── *Repository.java
├── dto/
│   ├── request/
│   │   └── *Request.java
│   └── response/
│       └── *Response.java
├── entity/
│   └── *.java
├── exception/
│   ├── GlobalExceptionHandler.java
│   ├── ResourceNotFoundException.java
│   └── *.java
└── config/
    ├── ApplicationConfig.java
    └── OpenApiConfig.java
```

## Typical Output: 23-26 Files

- **Maven:** pom.xml
- **Config:** application.yml, 1-2 config classes
- **Controllers:** 1-2 REST controllers with Swagger
- **Services:** 1-2 service interfaces + implementations
- **Repositories:** 1-2 repository interfaces
- **DTOs:** 4-6 request/response classes
- **Entities:** 1-2 domain models
- **Exceptions:** GlobalExceptionHandler + 2-3 custom exceptions
- **Docs:** 5+ documentation files (README, quick start, etc.)

## Quality Guaranteed

✅ 100% pattern compliance (verified via 3 evals)  
✅ Constructor injection only (Lombok @RequiredArgsConstructor)  
✅ DTO separation enforced  
✅ Centralized exception handling  
✅ Swagger/OpenAPI integrated  
✅ Production-ready code  
✅ Comprehensive documentation  
✅ Zero boilerplate after generation  

## Test Results

| Scenario | Duration | Files | Status |
|----------|----------|-------|--------|
| customer-service | 655s | 23 | ✅ PASSED |
| order-processor | 487s | 26 | ✅ PASSED |
| user-auth-service | 489s | 26 | ✅ PASSED |

## Example Usage Flow

```
You: "Create a new Spring Boot service for managing payments"
     Service name: payment-service
     Package: com.acme.finance
     Port: 8086

Skill: Generates 25 files
     ✅ pom.xml with Spring Boot 4.0.3
     ✅ application.yml on port 8086
     ✅ PaymentController with Swagger
     ✅ PaymentService with business logic
     ✅ PaymentRepository interface
     ✅ PaymentRequest/PaymentResponse DTOs
     ✅ GlobalExceptionHandler
     ✅ Custom exceptions
     ✅ 5+ documentation files

You: Extract files → mvn install → add domain logic → deploy
```

## Tips

1. **Have these ready:** Project name, base package, port number
2. **Customize after:** Add your domain entities, customize pom.xml if needed
3. **Build immediately:** `mvn clean install` to verify everything
4. **Follow the docs:** README and quick-start guides included
5. **Use as template:** First project becomes template for next ones

## Get Help

All generated projects include:
- README.md - Comprehensive setup guide
- HELP.md - Quick troubleshooting
- INDEX.md - File navigation
- Architecture documentation
- API reference with Swagger

## Contact/Updates

Skill created: 2026-04-08  
Version: 1.0  
Status: Production Ready  
Test Coverage: 3 comprehensive scenarios, 100% pass rate
