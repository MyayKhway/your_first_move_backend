# Your First Move

The "Your First Move" application is designed to assist car buyers in finding suitable vehicles based on their preferences such as location, budget, and family size. The system simplifies the car selection process by offering personalized recommendations, allowing users to compare multiple vehicles and access real-time information on prices and dealership offers. It also provides a dashboard for administrators to update vehicle details and monitor user engagement.

## Dev setup

Postgres database can be set up as a docker container so you do not have to worry about schema initialization.

```docker
docker compose -f dev-db.yaml up -d
```

should do the trick.
