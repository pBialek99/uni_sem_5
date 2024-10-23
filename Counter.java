import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

class Counter extends Thread {
    private int x = 0;
    private final Lock lock = new ReentrantLock();
    
    public void increment() {
        lock.lock();
        try {
            x++;
        } finally {
            lock.unlock();
        }
    }
    
    public int getValue() {
        lock.lock();
        try {
            return x;
        } finally {
            lock.unlock();
        }
    }
}
