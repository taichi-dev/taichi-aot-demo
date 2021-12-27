package com.example.mpm88ndarray;

public class Ndarray {
    private int dim;
    private int ssbo;
    private int total_size;
    private int shape_offset;
    private int[] shape;
    private int[] element_shape;
    public boolean init;

    public Ndarray(int dim, int shape_offset, int total_size, int[] shape, int[] element_shape) {
        this.dim = dim;
        this.shape_offset = shape_offset;
        this.total_size = total_size;
        this.shape = shape;
        this.element_shape = element_shape;
        this.init = false;
    }

    public int getDim() {
        return dim;
    }

    public int getSsbo() {
        return ssbo;
    }

    public void setSsbo(int ssbo) {
        this.ssbo = ssbo;
    }

    public void setShape(int[] shape) {
        this.shape = shape;
    }

    public int[] getShape() {
        return shape;
    }

    public int getTotal_size() {
        return total_size;
    }

    public int[] getElement_shape() {
        return element_shape;
    }

    public int getShape_offset() {
        return shape_offset;
    }
}
