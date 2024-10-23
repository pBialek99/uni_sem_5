class MyThread extends Thread {
    private final int i;

    MyThread(int i) {
        this.i = i;
    }

    public void run() {
        System.out.println("Watek " + this.i);
    }
}
