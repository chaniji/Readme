# MongoDB Auth Error Fix — Spring Boot 4.x

## Error
```
UncategorizedMongoDbException: Command execution failed on MongoDB server with error 13 (Unauthorized):
'Command find requires authentication' on server localhost:27017.
```

## Root Cause
Spring Boot 4.x ignores `application.properties` MongoDB URI credentials during auto-configuration.
MongoClient is created without auth → MongoDB rejects all commands.

## What Doesn't Work
```properties
# These are IGNORED in Spring Boot 4.x
spring.data.mongodb.uri=mongodb://chan:1234@localhost:27017/inventorydb?authSource=admin
spring.data.mongodb.host=localhost
spring.data.mongodb.port=27017
spring.data.mongodb.username=chan
spring.data.mongodb.password=1234
spring.data.mongodb.authentication-database=admin
```

## Fix — Explicit MongoConfig.java

Create `src/main/java/com/Chan/InventoryService/Config/MongoConfig.java`:

```java
package com.Chan.InventoryService.Config;

import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoClients;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class MongoConfig {
    @Bean
    public MongoClient mongoClient() {
        return MongoClients.create(
            "mongodb://chan:1234@localhost:27017/inventorydb?authSource=admin"
        );
    }
}
```

This bypasses broken auto-config and forces credentials manually.

## MongoDB Docker Setup (with auth)

```bash
# Fresh container with auth user built-in
docker run -d \
  --name mongodb \
  -p 27017:27017 \
  -e MONGO_INITDB_ROOT_USERNAME=chan \
  -e MONGO_INITDB_ROOT_PASSWORD=1234 \
  -v mongo_data:/data/db \
  mongodb/mongodb-community-server:latest
```

> Note: If reusing an existing volume, `MONGO_INITDB` env vars are ignored.
> Delete volume first: `docker volume rm mongo_data`

## Verify User Exists in MongoDB

```bash
docker exec -it mongodb mongosh -u chan -p 1234 --authenticationDatabase admin
```
```js
use admin
db.getUsers()
```

## Stack
- Spring Boot 4.x
- spring-boot-starter-data-mongodb
- MongoDB Community Server (Docker)
- ERP Inventory Service (port 8083)
