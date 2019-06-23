public class App {

    static {
        System.out.println("Setup ShutdownHook");
        Runtime.getRuntime().addShutdownHook(new Thread(() -> {
            System.out.println("Received Shutdown signal");
            System.out.println("Exit application by ShutdownHook");
            System.exit(0);
        }));
    }

    public static void main(String[] args) throws Exception {
        System.out.println("Started application");

        if(args.length > 0) {
            long sleep = Long.parseLong(args[0]);

            System.out.println("Sleeping " + sleep + " milliseconds");
            Thread.sleep(sleep);
        }

        System.out.println("Exit application normally");
    }
}