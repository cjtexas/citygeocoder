test_that("basic geocode works", {
  expect_true(all(!is.na(geocode())))
})

test_that("geocode returns data.frame", {
  expect_true("data.frame" %in% class(geocode()))
})

test_that("geocode returns known value", {
  expect_equivalent(geocode("Boerne", "TX"), data.frame(lon = -98.7319702, lat = 29.7946641))
})

test_that("geocode handles NA values", {
  expect_true(nrow(geocode(NA))==1)
})
