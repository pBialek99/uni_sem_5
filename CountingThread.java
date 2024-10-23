class CountingThread extends Thread {
    private final int threadNumber;

    CountingThread(int threadNumber) {
        this.threadNumber = threadNumber;
    }

    public void run() {
        for (int i = 1; i <= 10; i++) {
            System.out.println("Watek " + threadNumber + ": " + i);
        }
    }
}
