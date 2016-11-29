package es.molestudio.gogarage.model;

import java.util.Date;

/**
 * Created by ricardomaqueda on 27/01/16.
 */
public class Vehicle extends BaseModel {

    private String nick;
    private String brand;
    private String model;
    private String color;
    private String registrationNumber;
    private String chassisNumber;
    private Date manufacturedDate;
    private String vehicleDescription;


    public Vehicle(Number objectId,
                   Date created_at,
                   Date updated_at,
                   String nick,
                   String brand,
                   String model,
                   String color,
                   String registrationNumber,
                   String chassisNumber,
                   Date manufacturedDate,
                   String vehicleDescription)
    {
        super(objectId, created_at, updated_at);
        this.nick = nick;
        this.brand = brand;
        this.model = model;
        this.color = color;
        this.registrationNumber = registrationNumber;
        this.chassisNumber = chassisNumber;
        this.manufacturedDate = manufacturedDate;
        this.vehicleDescription = vehicleDescription;
    }
}
