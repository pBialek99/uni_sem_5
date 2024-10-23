class Printer {
    public synchronized void printNumbers(int mod) {
        for (int i = 0; i <= 10; i++) {
            System.out.println("Number: " + (i * mod));
        }
    }
}
