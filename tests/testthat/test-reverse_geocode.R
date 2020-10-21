test_that("basic reverse geocode works", {
  expect_true(all(!is.na(reverse_geocode())))
})

test_that("reverse geocode returns data.frame", {
  expect_true("data.frame" %in% class(reverse_geocode()))
})

test_that("reverse geocode returns known value", {
  expect_true(reverse_geocode(lon=-101.68181, lat=34.61681)$city=="Tulia")
})

test_that("reverse geocode does not handle NA values", {
  expect_error(reverse_geocode(NA))
})
