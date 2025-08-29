# AirBnB Database Entity-Relationship Diagram

## Overview
This directory contains the Entity-Relationship (ER) diagram for the AirBnB database system, designed to model the core functionality of a property rental platform.

## Database Entities
The ER diagram includes the following entities:

- **User**: Guests, hosts, and administrators
- **Property**: Rental listings managed by hosts
- **Booking**: Reservation records linking users and properties
- **Payment**: Payment transactions for bookings
- **Review**: User reviews and ratings for properties
- **Message**: Communication between users

## Tools Used
This ER diagram was created using **Draw.io** (diagrams.net), a free online diagramming tool.

## Viewing the Diagram

### Option 1: Online (Recommended)
1. Visit [https://app.diagrams.net](https://app.diagrams.net)
2. Click "Open Existing Diagram"
3. Upload the `.drawio` file from this directory
4. View and edit the diagram directly in your browser

### Option 2: Desktop Application
1. Download the Draw.io desktop app from [https://github.com/jgraph/drawio-desktop/releases](https://github.com/jgraph/drawio-desktop/releases)
2. Install the application on your system
3. Open the `.drawio` file using the desktop app
4. Full offline editing capabilities

## File Structure
```
ERD/
├── requirements.md          # This file
├── airbnb_er_diagram.drawio # Draw.io source file
└── airbnb_er_diagram.png    # PNG export of the diagram
```

## Key Features of the Database Design

### Entities and Relationships
- **User → Property**: One-to-many (Users can host multiple properties)
- **User → Booking**: One-to-many (Users can make multiple bookings)
- **Property → Booking**: One-to-many (Properties can have multiple bookings)
- **Booking → Payment**: One-to-one (Each booking has one payment)
- **User → Review**: One-to-many (Users can write multiple reviews)
- **Property → Review**: One-to-many (Properties can receive multiple reviews)
- **User → Message**: One-to-many (Users can send/receive multiple messages)

### Data Integrity Features
- Primary keys using UUIDs for all entities
- Foreign key constraints maintaining referential integrity
- ENUM constraints for status fields (booking status, user roles, payment methods)
- Rating constraints (1-5 scale) for reviews
- Unique constraints on user emails
- Proper indexing on frequently queried fields

## Technical Specifications
- **Primary Keys**: UUID format for scalability
- **Timestamps**: Automatic creation and update tracking
- **Data Types**: Optimized for performance and storage
- **Constraints**: Business rule enforcement at database level

## Usage
This ER diagram serves as the foundation for:
- Database schema creation
- API development planning
- Understanding data relationships
- Documentation for development teams

## Contributing
When modifying the ER diagram:
1. Update the `.drawio` source file
2. Export a new PNG version
3. Update this requirements file if entities or relationships change
4. Commit all changes with descriptive messages

## License
This project is part of the ALX Software Engineering program.
