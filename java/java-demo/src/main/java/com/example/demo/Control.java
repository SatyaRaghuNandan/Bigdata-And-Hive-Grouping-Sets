package com.example.demo;

public class Control {
	
	public static void test_switch() {  
//		switch 支持 int，char，和enum,string
		String str = "x";
		
        switch(str) {  
        case "abc":  
            System.out.println("abc");  
            break;  
        case "def":  
            System.out.println("def");  
            break;  
        default:  
            System.out.println("default");  
        }  
    } 
	
	public static void main(String[] args) {
		test_switch();
	}
	
	

}
