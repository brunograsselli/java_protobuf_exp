import com.blueapron.connect.protobuf.*;
import com.google.protobuf.*;
import java.util.Map;
import java.util.HashMap;

public class Main {
	public static void main(String[] args) throws NoSuchMethodException, ClassNotFoundException {
		System.out.println(com.bruno.proto.Messages.Person.class);
		System.out.println(com.bruno.proto.Messages.Person.newBuilder());
		System.out.println(com.bruno.proto.Messages.Person.class.getDeclaredMethod("newBuilder"));
		System.out.println(Class.forName("com.bruno.proto.Messages$Person").asSubclass(com.google.protobuf.GeneratedMessageV3.class).getDeclaredMethod("newBuilder"));
		ProtobufConverter converter = new ProtobufConverter();
		Map<String, String> config = new HashMap<>();
		config.put("protoClassName", "com.bruno.proto.Messages$Person");
		converter.configure(config, false);
		System.out.println(converter);
	}
}
