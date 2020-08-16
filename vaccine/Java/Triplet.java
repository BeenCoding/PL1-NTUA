//https://stackoverflow.com/questions/6010843/java-how-to-store-data-triple-in-a-list

public class Triplet<T, U, V> {

    private final T leftFlag;
    private final U right;
    private final V path;

    public Triplet(T leftFlag, U right, V path) {
        this.leftFlag = leftFlag;
        this.right = right;
        this.path = path;
    }

    public T getFlag() { return leftFlag; }
    public U getRight() { return right; }
    public V getPath() { return path; }
}
