import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

// Zadanie 8 i 9
class Counter extends Thread {
    private int x = 0;
    private final Lock lock = new ReentrantLock();
    
    public synchronized void increment() {
        lock.lock();
        try {
            x++;
        }
        finally {
            lock.unlock();
        }
    }
    
    
    public synchronized int getValue() {
        lock.lock();
        try {
            return x;
        }
        finally {
            lock.unlock();
        }
    }
}

// Zadanie 7
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

// Zadanie 5/6 - 6 ->dodane synchronized 
class Printer {
    public synchronized void printNumbers(int mod) {
        for (int i = 0; i <= 10; i++) {
            System.out.println("Number: " + (i*mod));
        }
    }
}

class MyPrinterThread extends Thread {
    private final Printer printer;
    private final int mod;
    
    MyPrinterThread(Printer printer, int mod) {
        this.printer = printer;
        this.mod = mod;
    }
    
    public void run() {
        printer.printNumbers(mod);
    }
    
}

// Zadanie 4
class CountingThread2 extends Thread {
    private final int threadNumber;
    private final int limit;

    CountingThread2(int threadNumber, int limit) {
        this.threadNumber = threadNumber;
        this.limit = limit;
    }

    public void run() {
        for (int i = 1; i <= limit; i++) {
            System.out.println("Watek: " + threadNumber + "INKREMENTACJA!");
            if (i % 100000 == 0) {
                System.out.println("Watek " + threadNumber + ": " + i);
                try {
                    Thread.sleep(500);
                }
                catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
        }
    }
}

// Zadanie 3
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

class MyThread extends Thread {
    private final int i;

    MyThread(int i) {
        this.i = i;
    }

    public void run() {
        System.out.println("Watek " + this.i);
    }
}

public class Main {
    public static void main(String[] args) {
        // Zadanie 1
        // proces -> instancja aplikacji
        // watek -> jednostka wykonawcza w procesie
        
        // Zadanie 2
        // Thread.sleep(10000)

        // Zadanie 3
        // List<CountingThread> threads = new ArrayList<>();

        // for (int i = 1; i <= 3; i++) {
        //     CountingThread thread = new CountingThread(i);
        //     threads.add(thread);
        //     thread.start();
        // }

        // for (CountingThread thread : threads) {
        //     try {
        //         thread.join();
        //     } catch (InterruptedException e) {
        //         e.printStackTrace();
        //     }
        // }

        // Zadanie 4
        // List<CountingThread2> threads2 = new ArrayList<>();

        // CountingThread2 thread1 = new CountingThread2(1, 100000);
        // CountingThread2 thread2 = new CountingThread2(2, 100000);

        // threads2.add(thread1);
        // threads2.add(thread2);
        // thread1.setPriority(Thread.MAX_PRIORITY);
        // thread1.start();
        // thread2.start();

        // for (CountingThread2 thread : threads2) {
        //     try {
        //         thread.join();
        //     } catch (InterruptedException e) {
        //         e.printStackTrace();
        //     }
        // }
    
        // Zadanie 5 i 6
        // Printer printer = new Printer();
        
        // MyPrinterThread thread1 = new MyPrinterThread(printer, 1);
        // MyPrinterThread thread2 = new MyPrinterThread(printer, 2);
        // MyPrinterThread thread3 = new MyPrinterThread(printer, 3);
        
        // thread1.start();
        // thread2.start();
        // thread3.start();
        
        // try {
        //     thread1.join();
        //     thread2.join();
        //     thread3.join();
        // }
        // catch (InterruptedException e) {
        //     e.printStackTrace();
        // }
        
        // Zadanie 7
        // Printer printer = new Printer();

        // List<Thread> printerThreads = new ArrayList<>();

        // for (int i = 1; i <= 3; i++) {
        //     MyPrinterRunnable printerRunnable = new MyPrinterRunnable(printer, i);
        //     Thread thread = new Thread(printerRunnable);
        //     printerThreads.add(thread);
        //     thread.start();
        // }

        // for (Thread thread : printerThreads) {
        //     try {
        //         thread.join();
        //     } 
        //     catch (InterruptedException e) {
        //         e.printStackTrace();
        //     }
        // }
        
        // Zadanie 8
        Counter counter = new Counter();

        Thread incrementThread = new Thread(() -> {
            for (int i = 0; i < 10; i++) {
                counter.increment();
                try {
                    Thread.sleep(100);
                } catch (InterruptedException e) {
                    Thread.currentThread().interrupt();
                }
            }
        });
        
        Thread getValueThread = new Thread(() -> {
            for (int i = 0; i < 10; i++) {
                System.out.println("Value is: " + counter.getValue());
                try {
                    Thread.sleep(100);
                } catch (InterruptedException e) {
                    Thread.currentThread().interrupt();
                }
            }
            
        });
        
        incrementThread.start();
        getValueThread.start();
        
        try {
            incrementThread.join();
            getValueThread.join();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        
    }
}
