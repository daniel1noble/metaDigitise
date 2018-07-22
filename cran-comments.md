
## CRAN revisions
	- Replaced \dontrun{} with donttest{} as requested. Note that metaDigitsie example requires \dontrun{} within example given the function requires user input.
	- Added vignette
	- Added more examples in functions. Please note that not all functions have examples as they are helper functions used in the major functions of the package. We have now tried to remove export of these. We do not anticipate users adopting them in normal use.
	- Fixed package name style in DESCRIPTION
	- Fixed metaDigitise example to ensure example writes to temp directory as suggested by CRAN maintainers
	- Fixed package title
	- Fixed up notes across the board
		- changed testthat and mockery to suggests and removed digitize package, which is no longer used
		- exported functions from various packages in Rcode

## Test environments
	- local Mac OSX High Sierra x86_64-apple-darwin15.6.0 (64-bit) - passed
	- Windows x86_64-w64-mingw32 (64-bit) - passed
	- Windows Server 2008 R2 SP1, R-release, x86_64-w64-mingw32 (64-bit) - passed
	- Debian Linux x86_64-pc-linux-gnu (64-bit) - passed
	- Ubuntu Linux 16.04 LTS, R-release, GCC - passed
	- CentOS 6, stock R from EPEL - passed

## R CMD check results

	# Local - Mac OS X
	    0 errors ✔| 0 warnings ✔| 0 notes ✔

	# Windows - Both 
	    0 errors ✔ | 0 warnings ✔ | 0 notes ✔

	# Debian Linux
		0 errors ✔ | 0 warnings ✔ | 0 notes ✔

## Reverse dependencies 

This is a new package and there are none.