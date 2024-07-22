## Flow Chart

```mermaid
flowchart TD
    %% Event Creation - Reservation Service
    subgraph Event Creation  [Reservation Service]
        A1[Event Created]
        A2[Send event info]
        A1 --> A2
    end
    
    %% Ticket Purchase - Reservation App
    subgraph Ticket Purchase [Reservation App]
        B1[Purchase ticket]
        B2[Send ticket number]
        B1 --> B2
    end
    
    %% User Registration and Authentication
    subgraph User Registration and Authentication
        C1[Download app]
        C2[Sign up]
        C3[Sign in]
        C1 --> C2 & C3
    end
    
    %% Joining the Chat Room
    subgraph Joining the Chat Room
        D1[Click 'Join Chat']
        D2[Enter ticket number]
        D3[Validate ticket number]
        D4[Associate ticket with user]
        D5[Mark ticket as used]
        D6[Add user to Chat Room]
        D1 --> D2 --> D3 --> D4 --> D5 --> D6
    end
    
    %% Chat Room Interaction
    subgraph Chat Room Interaction
        E1[View participants no messaging]
        E2[Chat room becomes active 2 hours before event]
        E3[Send/receive messages]
        E4[Store messages in Messages table]
        E1 --> E2 --> E3 --> E4
    end
    
    %% Notifications
    subgraph Notifications
        F1[Send notifications]
        
    end
    
    %% End of Event
    subgraph End of Event
        G1[Event ends]
        G2[Set chat room to inactive or delete]
        G3[Archive/delete messages]
        G1 --> G2 --> G3
    end
    
    %% Database Tables
    id1[(Events)]
    id2[(Users)]
    id3[(Chat Rooms)]
    id4[(Messages)]
    id5[(Notifications)]
    id6[(Tickets)]
    
    %% Connecting steps to Database Tables
    A2 -- Store in Events table --> id1 -- Create Chat Room status:inactive --> id3
    B2 -- Store in Tickets table --> id6 -- Associate ticket with event --> id1
    C2 -- Store in Users table --> id2
    C3 -- After sign in --> D1
    
    D3 -- Validate ticket in Tickets table --> id6
    D4 -- Associate ticket with user --> id6
    D5 -- Mark ticket as used -->id6
    D6 --> E1
    E3 -- Store messages --> id4
    E2 --Send chat room activated notfication --> F1
    F1 --Store notifications--> id5
    E4 --> G1
```

## Database design 
```mermaid
erDiagram
    Users {
        UUID id PK
        string username "unique, not null"
        string email "unique, not null"
        string password_hash "not null"
    }

    Events {
        UUID id PK
        string name "not null"
        string description "not null"
        naive_datetime start_time "not null"
        naive_datetime end_time "not null"
        string location "not null"
    }

    Tickets {
        UUID id PK
        UUID event_id FK
        string ticket_number "unique, not null"
        int user_id FK
    }

    ChatRooms {
        UUID id PK
        UUID event_id FK
        string status "not null, default: 'inactive'"
    }

    Messages {
        UUID id PK
        UUID chat_room_id FK
        UUID user_id FK
        string content "not null"
        string content_type "not null, default: 'text'"
    }

    Notifications {
        UUID id PK
        int user_id FK
        int event_id FK
        string message "not null"
        string status "not null, default: 'unread'"
    }

    Users ||--o{ Tickets : "has"
    Users ||--o{ Messages : "send"
    Users ||--o{ Notifications : "receive"
    Events ||--o{ Tickets : "include"
    Events ||--o{ Notifications : "trigger"
    Events ||--|| ChatRooms : "contain"
    ChatRooms ||--o{ Messages : "contain"
```
