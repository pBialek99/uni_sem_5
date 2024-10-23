class MyPrinterRunnable implements Runnable {
    private final Printer printer;
    private final int mod;

    MyPrinterRunnable(Printer printer, int mod) {
        this.printer = printer;
        this.mod = mod;
    }

    public void run() {
        printer.printNumbers(mod);
    }
}
