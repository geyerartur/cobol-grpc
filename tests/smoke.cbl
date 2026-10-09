IDENTIFICATION DIVISION.
PROGRAM-ID. smoke-test.

PROCEDURE DIVISION.
    DISPLAY "Before CALL".

    CALL "cobol-grpc".

    DISPLAY "After CALL".
    STOP RUN.

END PROGRAM smoke-test.
