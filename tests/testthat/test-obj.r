# Copyright 2016 Steven E. Pav. All Rights Reserved.
# Author: Steven E. Pav

# This file is part of fromo.
#
# fromo is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# fromo is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with fromo.  If not, see <http://www.gnu.org/licenses/>.

# env var:
# nb: 
# see also:
# todo:
# changelog: 
#
# Created: 2016.03.31
# Copyright: Steven E. Pav, 2016-2016
# Author: Steven E. Pav
# Comments: Steven E. Pav

# helpers#FOLDUP
set.char.seed <- function(str) {
	set.seed(as.integer(charToRaw(str)))
}
THOROUGHNESS <- getOption('test.thoroughness',1.0)
#UNFOLD

context("code runs at all")#FOLDUP
test_that("constructor and such",{#FOLDUP
	set.char.seed("33c133f6-930f-4656-88d4-84493784eee3")

	x <- rnorm(100)
	expect_error(csums <- cent_sums(x, max_order=5L, na_rm=TRUE),NA)
	expect_error(xobj <- centsums(csums),NA)

	foo <- sums(xobj)
	for (type in c('central','raw','standardized')) {
		moms <- moments(xobj,type=type)
	}
	expect_error(capture_output(show(xobj)),NA)

	expect_error(xobj <- as.centsums(x,order=5L, na.rm=TRUE),NA)
})#UNFOLD
test_that("cosum constructor and such",{#FOLDUP
	set.char.seed("817d965f-c3fb-439b-92ef-8c42452688ea")

	x <- matrix(rnorm(30*3),ncol=3)
	expect_error(csums <- cent_cosums(x, max_order=2L, na_omit=TRUE),NA)
	expect_error(xobj <- centcosums(csums),NA)

	foo <- cosums(xobj)
	for (type in c('central','raw')) {
		expect_error(moms <- comoments(xobj,type=type),NA)
	}
	expect_error(capture_output(show(xobj)),NA)

	expect_error(xobj <- as.centcosums(x,order=2L, na.omit=TRUE),NA)
})#UNFOLD
# 2FIX: check the effects of NA
#UNFOLD
context("correctness")#FOLDUP
test_that("monoidal homomorphism",{#FOLDUP
	set.char.seed("3fb6ab54-f5b9-4965-8a76-477dd62d6d7e")

	x <- rnorm(100)
	y <- rnorm(100)
	order <- 5L
	expect_error(xobj <- as.centsums(x,order=order, na.rm=TRUE),NA)
	expect_error(yobj <- as.centsums(y,order=order, na.rm=TRUE),NA)
	expect_error(zobj <- as.centsums(c(x,y),order=order, na.rm=TRUE),NA)

	zalt <- c(xobj,yobj)
	expect_equal(sums(zalt),sums(zobj),tolerance=1e-9)

	expect_error(xalt <- zobj %-% yobj,NA)
	expect_error(yalt <- zobj %-% xobj,NA)
	expect_equal(sums(xalt),sums(xobj),tolerance=1e-9)
	expect_equal(sums(yalt),sums(yobj),tolerance=1e-9)
})#UNFOLD
test_that("cosums monoidal homomorphism",{#FOLDUP
	set.char.seed("68d7b935-7d0d-42a5-91e0-2ae711d92b35")

	x <- matrix(rnorm(100*4),ncol=4)
	y <- matrix(rnorm(100*4),ncol=4)
	order <- 2L
	expect_error(xobj <- as.centcosums(x,order=order, na.omit=TRUE),NA)
	expect_error(yobj <- as.centcosums(y,order=order, na.omit=TRUE),NA)
	expect_error(zobj <- as.centcosums(rbind(x,y),order=order, na.omit=TRUE),NA)

	zalt <- c(xobj,yobj)
	expect_equal(cosums(zalt),cosums(zobj),tolerance=1e-9)

	expect_error(xalt <- zobj %-% yobj,NA)
	expect_error(yalt <- zobj %-% xobj,NA)
	expect_equal(cosums(xalt),cosums(xobj),tolerance=1e-9)
	expect_equal(cosums(yalt),cosums(yobj),tolerance=1e-9)
})#UNFOLD
test_that("cosums make zero?",{#FOLDUP
	set.char.seed("5fbdb6e1-64ee-48dd-9131-98c66cfd1486")

	x <- matrix(rnorm(100*4),ncol=4)
	y <- matrix(rnorm(100*4),ncol=4)
	order <- 2L
	expect_error(xobj <- as.centcosums(x,order=order, na.omit=TRUE),NA)
	expect_error(yobj <- as.centcosums(y,order=order, na.omit=TRUE),NA)
	# x - x = 0
	expect_error(allz <- xobj %-% xobj,NA)
	expect_true(all(cosums(allz)==0))

	# x + 0 = x
	# 0 + y = y
	xalt <- c(xobj,allz)
	yalt <- c(allz,yobj)
	expect_equal(cosums(xalt),cosums(xobj),tolerance=1e-9)
	expect_equal(cosums(yalt),cosums(yobj),tolerance=1e-9)
})#UNFOLD
test_that("cosums bad input?",{#FOLDUP
	set.char.seed("6e06ef0e-fb0e-4adb-b27d-028db8028f20")

	x <- matrix(rnorm(100*4),ncol=4)
	y <- matrix(rnorm(100*6),ncol=6)

	order <- 2L
	expect_error(xobj <- as.centcosums(x,order=order, na.omit=TRUE),NA)
	expect_error(yobj <- as.centcosums(y,order=order, na.omit=TRUE),NA)

	# these should all be erorrs??
	#expect_error(c(xobj,yobj))
	#expect_error(xobj %-% yobj)
})#UNFOLD


# 2FIX: check the effects of NA
#UNFOLD

#for vim modeline: (do not edit)
# vim:ts=2:sw=2:tw=79:fdm=marker:fmr=FOLDUP,UNFOLD:cms=#%s:syn=r:ft=r:ai:si:cin:nu:fo=croql:cino=p0t0c5(0:
