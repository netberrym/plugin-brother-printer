package brother.printer.plugin;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.util.Base64;
import android.util.Log;

import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.ByteArrayInputStream;
import java.io.InputStream;
import java.util.Objects;

import com.example.brotherdll.BrotherActivity;


/**
 * This class echoes a string called from JavaScript.
 */
public class brotherprinterplugin extends CordovaPlugin {

	public static final String TAG = "BrotherPrinter";
	BrotherActivity BrotherDll_BT = new BrotherActivity();

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        if (action.equals("print")) {
            this.print(args, callbackContext);
            return true;
        }
        return false;
    }

    private void print(JSONArray args, CallbackContext callbackContext) {
         /* if (message != null && message.length() > 0) {
            callbackContext.success(message);
        } else {
            callbackContext.error("Expected one non-empty string argument.");
        }
 */
		try{
			// Obtiene los valores
			JSONObject object = args.getJSONObject(0);
			// Conecta con la impresora
			String conexion = BrotherDll_BT.openport(object.getString("mac"));

			if(Objects.equals(conexion, "-1")){
				callbackContext.error("No se ha podido establecer conexión con la impresora. Revisa la conexión.");
			}

			// Configuración de la impresora
			Integer heightPapper = Integer.parseInt(object.getString("heightPapper"));
			BrotherDll_BT.setup(75, heightPapper, 2, 15, 0, 0, 0);

			// Recoge los datos de la image en base 64
			Bitmap bitmap = bmpFromBase64(object.getString("base64"));
			Integer height = Integer.parseInt(object.getString("height"));
			BrotherDll_BT.sendImagebyFile(bitmap, 0, 0, 550, height, 200);

			// Desconecta
			BrotherDll_BT.closeport(5000);

			callbackContext.success("ok");
		} catch (Exception e) {
			callbackContext.error(e.getMessage());
		}
	}

	private Bitmap bmpFromBase64(String base64) {
		try {
			byte[] bytes = Base64.decode(base64, Base64.DEFAULT);
			InputStream stream = new ByteArrayInputStream(bytes);

			return BitmapFactory.decodeStream(stream);
		} catch (Exception e) {
			Log.e(TAG, e + "");
			return null;
		}

    }
}
