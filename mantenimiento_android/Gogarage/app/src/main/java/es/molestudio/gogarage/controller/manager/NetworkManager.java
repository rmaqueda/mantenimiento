package es.molestudio.gogarage.controller.manager;

import android.content.Context;
import android.os.Build;
import android.os.StrictMode;
import android.util.Log;

import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.conn.scheme.Scheme;
import org.apache.http.conn.ssl.SSLSocketFactory;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.util.EntityUtils;
import org.json.JSONObject;

import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.security.KeyManagementException;
import java.security.KeyStore;
import java.security.KeyStoreException;
import java.security.NoSuchAlgorithmException;
import java.security.UnrecoverableKeyException;
import java.security.cert.CertificateException;
import java.util.ArrayList;

import es.molestudio.gogarage.R;

/**
 * Created by ricardomaqueda on 27/01/16.
 * http://stackoverflow.com/questions/1217141/self-signed-ssl-acceptance-android
 * keytool -import -v -trustcacerts -alias 0 -file ./molestudio.key -keystore ./certs.bks -storetype BKS -provider org.bouncycastle.jce.provider.BouncyCastleProvider -providerpath *./bcprov-jdk15on-146.jar -storepass PASSWORD
 */


public class NetworkManager extends DefaultHttpClient {

    private static String TAG = "NetworkManager";
    private static NetworkManager mInstance = null;
    private static Context mContext = null;
    private static Scheme mScheme = null;
    private static String mKey = null;

    public interface CodeBlock {
        void continueWithException(Exception e);
    }

    public static NetworkManager getInstance(Context context) {

        if(mInstance == null) {
            mInstance = new NetworkManager(context);
        }

        return mInstance;
    }

    private NetworkManager(Context context) {
        mContext = context;
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.HONEYCOMB) {
            StrictMode.ThreadPolicy policy = new StrictMode.ThreadPolicy.Builder().permitAll().build();
            StrictMode.setThreadPolicy(policy);
        }

        if (mScheme == null) {
            try {
                mScheme = new Scheme("https", mySSLSocketFactory(), 8075);
            } catch (Exception e) {
                Log.d("httpError", e.toString());
            }

        }

        getConnectionManager().getSchemeRegistry().register(mScheme);
    }

    private SSLSocketFactory mySSLSocketFactory() throws KeyStoreException,
            CertificateException,
            NoSuchAlgorithmException,
            IOException,
            UnrecoverableKeyException,
            KeyManagementException
    {
        SSLSocketFactory ret = null;

        final KeyStore keyStore = KeyStore.getInstance("BKS");
        final InputStream inputStream = mContext.getResources().openRawResource(R.raw.certs);

        keyStore.load(inputStream, mContext.getString(R.string.store_pass).toCharArray());
        inputStream.close();

        return new SSLSocketFactory(keyStore);
    }

    public void login(String username, String password, CodeBlock block) {
        Exception exception = null;
        try {
            ArrayList<NameValuePair> postParameters = new ArrayList<NameValuePair>();
            postParameters.add(new BasicNameValuePair("username", username));
            postParameters.add(new BasicNameValuePair("password", password));

            HttpPost httpQuery = new HttpPost("https://molestudio.es:8075/rest-auth/login/");
            httpQuery.setEntity(new UrlEncodedFormEntity(postParameters));
            HttpResponse httpResponse = this.execute(httpQuery);

            if (httpResponse.getStatusLine().getStatusCode() == HttpURLConnection.HTTP_OK) {
                String result = EntityUtils.toString(httpResponse.getEntity());
                JSONObject myObject = new JSONObject(result);
                mKey = (String) myObject.get("key");
                block.continueWithException(null);
            } else {
                block.continueWithException(new Exception(httpResponse.getStatusLine().getReasonPhrase()));
            }
        } catch (Exception ex){
            block.continueWithException(ex);
        }
    }
}
