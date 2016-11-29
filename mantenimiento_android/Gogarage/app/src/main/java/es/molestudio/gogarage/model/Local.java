package es.molestudio.gogarage.model;

import java.util.Date;

/**
 * Created by ricardomaqueda on 27/01/16.
 */
public class Local extends BaseModel {

    private String mName;
    private String mContact;
    private String mTelephone;
    private String mAddress;
    private String mLocalDescription;


    public Local(Number objectId, Date created_at, Date updated_at, String name, String contact, String telephone, String address, String localDescription) {
        super(objectId, created_at, updated_at);
        mName = name;
        mContact = contact;
        mTelephone = telephone;
        mAddress = address;
        mLocalDescription = localDescription;
    }
}
