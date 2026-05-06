---
name: springboot-project-creator
description: Generate a production-ready Spring Boot project scaffold matching your exact architectural patterns (3-tier layered architecture, repository pattern, DTO separation, exception handling, microservices-ready, PostgreSQL, Eureka, OpenAPI). Use this skill whenever a user wants to create a new Spring Boot microservice or application, start a new module following best practices, scaffold a project with proper structure, or generate a project template following your specific patterns. This skill creates actual project files ready to download and extend.
compatibility: Requires ability to generate and write multiple files
---

# Spring Boot Project Creator

## What This Skill Does

This skill generates a **complete, production-ready Spring Boot project scaffold** that matches your exact architectural patterns and conventions from your Employee Service. It creates:

- ✅ **Proper package structure** (Controller, Service, Repository, DTO, Entity, Exception, Config)
- ✅ **Base framework files** (pom.xml, configuration classes, global exception handler)
- ✅ **Your exact tech stack** (Spring Boot 4.0.3, PostgreSQL, JPA/Hibernate, Eureka, SpringDoc OpenAPI, Lombok)
- ✅ **Your coding style** (constructor injection, DTO request/response separation, lazy loading, validation patterns)
- ✅ **Ready-to-extend skeleton** (application.yml, base service/controller/repository templates, custom exceptions)

The generated project is **immediately usable** — clone it, run `mvn clean install`, and start implementing your domain entities.

---

## When to Use This Skill

Use this skill whenever the user wants to:
- Create a new Spring Boot microservice from scratch following proven architectural patterns
- Generate a new module or project with your preferred package structure and conventions
- Start a project with all configuration boilerplate pre-built
- Ensure new projects follow the same patterns for consistency
- Scaffold a project that's immediately ready for implementation (no setup guesswork)

---

## How to Use This Skill

### What You Need From the User

Before generating, **ask the user for**:

1. **Project Name** — Name of the microservice/module (e.g., "invoice-service", "user-management", "order-processor")
2. **Base Package Name** — Root Java package (e.g., "com.company.hr", "org.myapp.invoice", "io.github.myteam.users")
3. **Project Description** — What this service does (used in pom.xml and comments)
4. **Port Number** — Server port for this microservice (default: 8080)
5. **Database Name** — PostgreSQL database name (defaults to `{projectname}_db`)

### Generation Process

When you have the required information:

1. **Create the complete project structure** with these packages:
   ```
   src/main/java/
   ├── controller/          # REST controllers with @RestController
   ├── service/             # Business logic with @Service
   ├── repository/          # Data access with @Repository
   ├── dto/
   │   ├── request/         # Request DTOs with validation
   │   └── response/        # Response DTOs (no internal fields)
   ├── entity/              # JPA entities
   ├── exception/           # Custom exceptions
   ├── config/              # Spring configuration classes
   └── Application.java     # Main entry point
   ```

2. **Generate essential files** following your exact patterns:
   - `pom.xml` with your tech stack (Spring Boot 4.0.3, PostgreSQL, JPA, Eureka, SpringDoc, Lombok)
   - `application.yml` with Eureka, server port, database, JPA config
   - `GlobalExceptionHandler.java` (@RestControllerAdvice with your error handling pattern)
   - `ErrorResponse.java` (standardized error response DTO)
   - Base `*Request.java` and `*Response.java` templates
   - Base `*Repository.java` extending JpaRepository
   - Base `*Service.java` with @Service and @RequiredArgsConstructor
   - Base `*Controller.java` with @RestController and Swagger annotations

3. **Ensure your exact coding style** in all generated code:
   - Constructor injection with Lombok's `@RequiredArgsConstructor`
   - Separate request and response DTOs
   - Bean validation annotations (`@NotBlank`, `@Email`, etc.)
   - `maptoResponse()` methods in services
   - Lazy loading with `fetch = FetchType.LAZY`
   - Proper Swagger/OpenAPI annotations
   - No unnecessary comments (only where clarification is needed)

### Output Format

Generate all files as **readable text/code** that the user can:
- View inline in the chat
- Copy-paste into their IDE
- Download as individual files
- Assemble into their project directory

For **large projects** (many files), organize the output:
- Create a summary showing all files and their purposes
- Show each file separately with clear file paths
- Suggest how to organize them locally

---

## Your Architectural Patterns

This skill implements these specific patterns from your Employee Service:

### ✅ 3-Tier Layered Architecture
- **Controller Layer** — REST endpoints with `@RestController`, proper HTTP methods
- **Service Layer** — Business logic with `@Service`, entity-to-DTO mapping via `maptoResponse()`
- **Repository Layer** — Data access with `JpaRepository`, custom query methods

### ✅ DTO Pattern (Request ≠ Response ≠ Entity)
```java
// Request: Input validation only, no IDs
@PostMapping
public ResponseEntity<UserResponse> createUser(@RequestBody @Valid UserRequest request)

// Response: Only necessary fields exposed, no internal details
public class UserResponse {
  private Long id;
  private String name;  // No password, no internal fields
}

// Entity: Full JPA entity, never exposed to API
@Entity
@Table(name = "users")
public class User { /* ... */ }
```

### ✅ Exception Handling Pattern
- Centralized `@RestControllerAdvice` with specific exception handlers
- Standardized `ErrorResponse` DTO with (statusCode, message, timestamp)
- Custom exceptions extending `RuntimeException`

### ✅ Validation Pattern
- Bean Validation annotations on Request DTOs: `@NotBlank`, `@Email`, `@NotNull`, `@Valid`
- Declarative validation at API boundary
- `BindingResult` for error details if needed

### ✅ Pagination Support
- `Pageable` interface integration in services
- `Page<T>` return types
- `@PageableDefault` annotations

### ✅ Relationship Management
- Lazy loading with `fetch = FetchType.LAZY` (prevents N+1 queries)
- Cascade operations with `cascade = CascadeType.ALL`
- Bidirectional relationships properly configured

### ✅ Dependency Injection
- Constructor injection via Lombok's `@RequiredArgsConstructor`
- `private final` fields (immutable, testable)
- No field injection (@Autowired on fields)

### ✅ API Documentation
- SpringDoc OpenAPI (Swagger) integration
- `@Tag`, `@Operation`, `@Schema` annotations
- Auto-generated docs at `/swagger-ui.html`

---

## Code Style Guidelines

All generated code follows these conventions:

```java
// Lombok usage
@Entity
@Getter @Setter
@RequiredArgsConstructor
@AllArgsConstructor
@Builder
public class User { }

// Service layer
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class UserService {
  private final UserRepository repository;
  
  public UserResponse createUser(UserRequest request) {
    // ... business logic
    return maptoResponse(user);
  }
  
  private UserResponse maptoResponse(User entity) {
    // Manual mapping (not MapStruct for simplicity)
  }
}

// Exception handling
@RestControllerAdvice
public class GlobalExceptionHandler {
  @ExceptionHandler(ResourceNotFoundException.class)
  @ResponseStatus(HttpStatus.NOT_FOUND)
  public ErrorResponse handleNotFound(ResourceNotFoundException ex) {
    return new ErrorResponse(404, ex.getMessage(), LocalDateTime.now());
  }
}

// Constructor injection
@RestController
@RequestMapping("/api/users")
@RequiredArgsConstructor
public class UserController {
  private final UserService service;
  
  @GetMapping("/{id}")
  public ResponseEntity<UserResponse> getUser(@PathVariable Long id) {
    return ResponseEntity.ok(service.getUser(id));
  }
}
```

---

## Post-Generation Steps

After generating the scaffold, advise the user to:

1. **Extract the files** into their local project directory
2. **Customize** `pom.xml` if adding additional dependencies
3. **Update** `application.yml` with actual PostgreSQL credentials and Eureka server details
4. **Run** `mvn clean install` to verify the build
5. **Start implementing** domain entities by extending the generated base classes
6. **Test** with Spring's testing annotations (`@SpringBootTest`, `@DataJpaTest`)

---

## Key Features

- ✅ **Production-ready** — Not hello-world, but real structure
- ✅ **Your exact patterns** — Mirrors your Employee Service architecture
- ✅ **Copy-paste friendly** — All files ready to use immediately
- ✅ **Extensible** — Scaffold designed for your domain entities
- ✅ **Best practices** — SOLID principles, clean architecture, microservices-ready
- ✅ **Fully configured** — pom.xml, application.yml, exception handling, validation

---

## Example Invocation

**User:** "I need to create a new Spring Boot service for managing invoices. Base package is `com.acme.billing`."

**Skill Output:**
1. Shows project structure overview
2. Generates all files with proper package structure
3. Provides `pom.xml`, `application.yml`, exception handler, base DTOs, service template, controller template, repository template
4. Shows how to extract and customize
5. Links to key configuration parameters

User gets a complete scaffold ready to implement their `Invoice` entity and business logic.
