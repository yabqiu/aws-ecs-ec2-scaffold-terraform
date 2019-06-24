import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.concurrent.atomic.AtomicLong;

public class WebApp {
    private final static int TCP_PORT = 8080;

    private static boolean shutdown = false;
    private static AtomicLong count = new AtomicLong();

    static {
        System.out.println("Setup ShutdownHook");
        Runtime.getRuntime().addShutdownHook(new Thread(() -> {
            System.out.println("Received Shutdown signal");
            System.out.println("Exit application by ShutdownHook");
            shutdown = true;
        }));
    }

    public static void main(String[] args) throws IOException {
        ServerSocket ss = new ServerSocket(TCP_PORT);
        System.out.println("Listening to " + TCP_PORT);

        while (!shutdown) {
            Socket socket = ss.accept();

            BufferedReader br = new BufferedReader(new InputStreamReader(socket.getInputStream()));
            String buffer;
            while ((buffer = br.readLine()) != null && !buffer.equals("")) {
                System.out.println(buffer);
            }

            BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(socket.getOutputStream()));
            bw.write("HTTP/1.1 200 OK\n");
            bw.write("Content-Type: text/html; charset=UTF-8\n\n");
            bw.write(String.join(System.lineSeparator(),
                "<html>",
                "  <head>",
                "    <title>first page</title>",
                "  </head>",
                "  <body>",
                "    <h1>Hello Web Server! Count: " + count.incrementAndGet() + "</h1>",
                "  </body>",
                "</html>\n"));
            bw.flush();
            bw.close();
        }

        ss.close();
    }
}
