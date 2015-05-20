rem  Timestamp Code

rem Create the date and time elements.
For /f "tokens=1-7 delims=:/-, " %%i in ('echo exit^|cmd /q /k"prompt $D $T"') do (
	For /f "tokens=2-4 delims=/-,() skip=1" %%a in ('echo.^|date') do (
		set dow=%%i
		set %%a=%%j
		set %%b=%%k
		set %%c=%%l
		set hh=%%m
		set min=%%n
		set ss=%%o
	)
)

rem Let's see the result.
For %%i in (dow dd mm yy hh min ss) do set %%i