class CountingThread2 extends Thread {
    private final int threadNumber;
    private final int limit;

    CountingThread2(int threadNumber, int limit) {
        this.threadNumber = threadNumber;
        this.limit = limit;
    }

    public void run() {
        for (int i = 1; i <= limit; i++) {
            if (i % 100000 == 0) {
                System.out.println("Watek " + threadNumber + ": " + i);
                try {
                    Thread.sleep(500);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
        }
    }
}
