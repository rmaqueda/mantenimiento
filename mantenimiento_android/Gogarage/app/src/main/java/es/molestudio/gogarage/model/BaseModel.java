package es.molestudio.gogarage.model;

import java.util.Date;

/**
 * Created by ricardomaqueda on 27/01/16.
 */
public class BaseModel {

    private Number mObjectId;
    private Date mCreated_at;
    private Date mUpdated_at;

    public BaseModel(Number objectId, Date created_at, Date updated_at) {
        mObjectId = objectId;
        mCreated_at = created_at;
        mUpdated_at = updated_at;
    }
}
