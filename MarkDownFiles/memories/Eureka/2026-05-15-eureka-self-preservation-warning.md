---
date: 2026-05-15
tags: [memory, eureka, spring-cloud, erp]
---

# Eureka Self-Preservation Warning

## Error / Warning

```
EMERGENCY! EUREKA MAY BE INCORRECTLY CLAIMING INSTANCES ARE UP WHEN THEY'RE NOT.
RENEWALS ARE LESSER THAN THRESHOLD AND HENCE THE INSTANCES ARE NOT BEING EXPIRED JUST TO BE SAFE.
```

Dashboard shows:
- `Renews threshold: 3`
- `Renews (last min): 0`

## Cause

Eureka expects heartbeats from registered instances.
When heartbeat count < threshold → Self-Preservation Mode activates.

Common in dev when not all services are running.

## NOT a real error if

- Only 1-2 services started (dev/test)
- Eureka just booted (`uptime: 00:00`)
- Heartbeats haven't arrived yet

## Fix (Dev Only)

Add to `eureka-server/src/main/resources/application.properties`:

```properties
eureka.server.enable-self-preservation=false
eureka.server.eviction-interval-timer-in-ms=5000
```

> ⚠️ Do NOT disable in production.

## ERP Context

- Triggered when only `INVENTORYSERVICE` running on `192.168.29.110:8083`
- Other 5 services not started → threshold not met → warning fires
- Start all 6 services → warning disappears automatically

## Summary

| Situation | Action |
|---|---|
| Dev, partial services running | Ignore or disable self-preservation |
| All services running + warning | Check heartbeat config / network |
| Production | Never disable self-preservation |

## Related

- Spring Cloud Eureka Self-Preservation docs
- ERP Repo: github.com/chaniji/ERP
