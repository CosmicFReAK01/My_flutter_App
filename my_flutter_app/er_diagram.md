# LaundryMate App - Entity Relationship Diagram

## ER Diagram (Mermaid Format)

```mermaid
erDiagram
    USER {
        int id PK
        string name
        string email
        string phone
        string role
        datetime join_date
        boolean active
    }
    
    CUSTOMER {
        int id PK
        int user_id FK
        string full_name
        string email
        string phone
        int total_orders
        int completed_orders
        int pending_orders
        datetime last_order_date
        string status
    }
    
    CONSUMER {
        int id PK
        int user_id FK
        string shop_name
        string address
        string description
        string specialties
        int years_experience
        string turnaround_time
        boolean doorstep_service
        boolean express_service
        boolean active
        datetime created_at
    }
    
    ADDRESS {
        int id PK
        int customer_id FK
        string type
        string name
        string phone
        string address_line
        boolean is_default
    }
    
    SERVICE {
        int id PK
        int consumer_id FK
        string name
        string description
        decimal price
        string unit
        string duration
        string category
        boolean active
        datetime created_at
    }
    
    ORDER {
        int id PK
        string order_number
        int customer_id FK
        int consumer_id FK
        int address_id FK
        string status
        decimal total_amount
        datetime order_date
        datetime pickup_date
        datetime delivery_date
        datetime estimated_delivery
        string notes
    }
    
    ORDER_ITEM {
        int id PK
        int order_id FK
        int service_id FK
        string title
        string provider_name
        int quantity
        decimal unit_price
        decimal total_price
        string notes
    }
    
    CART_ITEM {
        int id PK
        int customer_id FK
        string title
        string provider_name
        string services
        string price
        datetime added_at
    }
    
    NOTIFICATION {
        int id PK
        int user_id FK
        string title
        string message
        string type
        boolean read
        datetime created_at
    }
    
    ANALYTICS {
        int id PK
        int consumer_id FK
        string metric_name
        decimal value
        string period
        datetime recorded_at
    }

    %% Relationships
    USER ||--o{ CUSTOMER : "can be"
    USER ||--o{ CONSUMER : "can be"
    
    CUSTOMER ||--o{ ADDRESS : "has"
    CUSTOMER ||--o{ ORDER : "places"
    CUSTOMER ||--o{ CART_ITEM : "has"
    CUSTOMER ||--o{ NOTIFICATION : "receives"
    
    CONSUMER ||--o{ SERVICE : "offers"
    CONSUMER ||--o{ ORDER : "fulfills"
    CONSUMER ||--o{ NOTIFICATION : "receives"
    CONSUMER ||--o{ ANALYTICS : "tracks"
    
    ORDER ||--o{ ORDER_ITEM : "contains"
    ORDER }o--|| ADDRESS : "delivered to"
    
    SERVICE ||--o{ ORDER_ITEM : "included in"
    
    USER ||--o{ NOTIFICATION : "receives"
```

## Entity Descriptions

### Core Entities

**USER**
- Base entity for all app users
- Contains common authentication and profile data
- Role field determines if user is customer or consumer

**CUSTOMER** 
- Extends USER for customers who book laundry services
- Tracks order statistics and customer status
- Links to orders, addresses, and cart items

**CONSUMER**
- Extends USER for laundry service providers
- Contains shop details, services offered, and business info
- Links to services, orders they fulfill, and analytics

### Service & Order Management

**SERVICE**
- Laundry services offered by consumers
- Includes pricing, duration, category (Regular/Premium/Express)
- Can be active/inactive

**ORDER**
- Central entity for laundry bookings
- Links customer, consumer, delivery address
- Tracks status progression and dates

**ORDER_ITEM**
- Individual services within an order
- Links to specific services with quantities and pricing

**CART_ITEM**
- Temporary storage for services before checkout
- Belongs to specific customer

### Supporting Entities

**ADDRESS**
- Customer delivery addresses
- Supports multiple addresses per customer (Home, Office, etc.)

**NOTIFICATION**
- System notifications for both customers and consumers
- Supports different notification types

**ANALYTICS**
- Business metrics tracking for consumers
- Stores various KPIs and performance data

## Key Relationships

1. **User Inheritance**: USER entity is extended by CUSTOMER and CONSUMER
2. **Order Flow**: CUSTOMER places ORDER → contains ORDER_ITEM → references SERVICE
3. **Service Management**: CONSUMER offers multiple SERVICE entities
4. **Address Management**: CUSTOMER has multiple ADDRESS options
5. **Cart System**: CUSTOMER accumulates CART_ITEM before creating ORDER
6. **Notifications**: Both user types receive NOTIFICATION entities
7. **Analytics**: CONSUMER tracks business ANALYTICS

## Data Storage Notes

- Currently using in-memory storage (List<Map<String, dynamic>>)
- No persistent database implementation detected
- Uses singleton managers (CartManager, OrderManager) for state management
- SharedPreferences used for simple key-value storage
