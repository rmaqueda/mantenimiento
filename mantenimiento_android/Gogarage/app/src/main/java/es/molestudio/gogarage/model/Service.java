package es.molestudio.gogarage.model;

import java.util.Date;

/**
 * Created by ricardomaqueda on 27/01/16.
 */
public class Service extends BaseModel {

    private String mType;
    private String mServiceDescription;


    public Service(Number objectId, Date created_at, Date updated_at, String type, String serviceDescription) {
        super(objectId, created_at, updated_at);
        mType = type;
        mServiceDescription = serviceDescription;
    }
}
