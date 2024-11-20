package com.example.camping;


import java.io.PrintWriter;
import java.io.StringWriter;
import java.time.LocalDateTime;

public class CustomException extends Exception {
    private final LocalDateTime timestamp;
    private final String stackTrace;
    private final String errorDescription;

    /** Exception personnalisee
     *
     * @param message
     * @param errorDescription
     * @param cause
     */
    public CustomException(String message, String errorDescription, Throwable cause) {
        super(message, cause);
        this.timestamp = LocalDateTime.now();
        StringWriter sw = new StringWriter();
        cause.printStackTrace(new PrintWriter(sw));
        this.stackTrace = sw.toString();
        this.errorDescription = errorDescription;
    }

    /** Exception Personnalisee
     *
     * @param message
     * @param errorDescription
     */
    public CustomException(String message, String errorDescription) {
        super(message);
        this.timestamp = LocalDateTime.now();
        this.stackTrace = "";
        this.errorDescription = errorDescription;
    }

    /** Get Timestamp
     *
     * @return
     */
    public LocalDateTime getTimestamp() {
        return timestamp;
    }

    /** Get StackTraceString
     *
     * @return
     */
    public String getStackTraceString() {
        return stackTrace;
    }

    /** Get ErrorDescription
     *
     * @return
     */
    public String getErrorDescription() {
        return errorDescription;
    }
}