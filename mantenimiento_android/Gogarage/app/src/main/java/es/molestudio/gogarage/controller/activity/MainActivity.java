package es.molestudio.gogarage.controller.activity;

import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;

import es.molestudio.gogarage.R;
import es.molestudio.gogarage.controller.manager.NetworkManager;

public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);



        NetworkManager networkManager = NetworkManager.getInstance(this);
        networkManager.login("ricardomaqueda", "a12345678", new NetworkManager.CodeBlock() {

            @Override
            public void continueWithException(Exception e) {
                if (e == null) {
                    Log.d("Main", "Login OK");
                } else {
                    Log.d("Main", "Login Error");
                }
            }
        });


    }
}
