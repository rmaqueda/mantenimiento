#!/usr/bin/env bash

# Create vehicle entry
curl -X "POST" $1"/api/1.0/vehicle/" \
	-H "Authorization: Basic cmljYXJkb21hcXVlZGE6dHQzMTMzMzE2cg==" \
	-H "Content-Type: application/json" \
	-d @jsons/vehicle.json

# Create Local entry
curl -X "POST" $1"/api/1.0/local/" \
	-H "Authorization: Basic cmljYXJkb21hcXVlZGE6dHQzMTMzMzE2cg==" \
	-H "Content-Type: application/json" \
	-d @jsons/local.json

# Create Service entry
curl -X "POST" $1"/api/1.0/service/" \
	-H "Authorization: Basic cmljYXJkb21hcXVlZGE6dHQzMTMzMzE2cg==" \
	-H "Content-Type: application/json" \
	-d @jsons/service.json


# Create MaintenanceBook entry
curl -X "POST" $1"/api/1.0/maintenancebook/" \
	-H "Authorization: Basic cmljYXJkb21hcXVlZGE6dHQzMTMzMzE2cg==" \
	-H "Content-Type: application/json" \
	-d @jsons/maintenanceBook.json


# Create Vehicle Image File entry
curl -X "POST" $1"/api/1.0/vehicleimage/" \
    -H "Authorization: Basic cmljYXJkb21hcXVlZGE6dHQzMTMzMzE2cg==" \
    -F "image=@./picasso.jpg;type=Content-Type:multipart/form-data" \
    -F "vehicle=1"