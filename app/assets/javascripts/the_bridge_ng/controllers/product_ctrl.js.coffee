@controllerModule.controller 'ProductController', ['$scope', '$location', '$http', '$routeParams', '$timeout', ($scope, $location, $http, $routeParams, $timeout) ->
  $scope.product = {}
  $scope.searchText = ""
  $scope.searchTagText = ""
  $scope.editTags = false


  $http.get('/products/' + $routeParams.id + '.json').success((data) ->
    $scope.product = data
    console.log($scope.product)
    productTags($scope.product)
    $scope.product.reviews_count = $scope.product.reviews.length
    $scope.productRating($scope.product)
    # console.log arguments
    #$scope.twitterApi = $scope.product.twitter.substring(1)
    #$timeout ->
    #  twttr.widgets.load()
    #, 500

  $scope.changeVoteFor = (product) ->
    $http.get("/products/#{product.id}/vote")
      .success (data) ->
        angular.extend(product,data)

      .error (data, status, headers, config) ->
        window.location="/login" if status == 401
        # console.log arguments

  $scope.changeReviewFor = (product) ->
    $http.get("/products/#{product.id}/review")
      .success (data) ->
        angular.extend(product,data)

      .error (data, status, headers, config) ->
        window.location="/login" if status == 401
        # console.log arguments

  $scope.searchAgain = () ->
    $location.path('/marketplace/search/' + $scope.searchText)

  $scope.productRating = (product) ->
    $http.get("/product/#{product.id}/rating").success((data) ->
      $scope.product.rating = data
  )

  $scope.upVote = (review) ->
    i = 0
    while i < $scope.product.reviews.length
      $scope.product.reviews[i].duplicate_upvote = false
      $scope.product.reviews[i].duplicate_downvote = false
      i++
    $http.get("/review/#{review.id}/up_vote").success((data) ->
      if data.status == 'login'
        window.location = data.redirect_url

      if data.status == 'duplicate'
        review.duplicate_upvote = true
        review.duplicate_downvote = false

      if data.status == 'success'
        if review.review_score == -1
          review.review_score = review.review_score + 2
        else
          review.review_score = review.review_score + 1
        review.duplicate_downvote = false
    )

  $scope.downVote = (review) ->
    i = 0
    while i < $scope.product.reviews.length
      $scope.product.reviews[i].duplicate_upvote = false
      $scope.product.reviews[i].duplicate_downvote = false
      i++
    $http.get("/review/#{review.id}/down_vote").success((data) ->
      if data.status == 'login'
        window.location = data.redirect_url

      if data.status == 'duplicate'
        review.duplicate_downvote = true
        review.duplicate_upvote = false

      if data.status == 'success'
        if review.review_score == 1
          review.review_score = review.review_score - 2
        else
          review.review_score = review.review_score - 1
        review.duplicate_upvote = false
    )


  $scope.reviewScore = (review,product) ->
    $http.get("/review/#{review.id}/score").success((data) ->
      i = 0
      while i < product.reviews.length
        if product.reviews[i].id == review.id
          $scope.product.reviews[i].review_score = data
        i++
  )

  $scope.submitReview = (product)->
    $scope.review =
      'review': $scope.post.review
      'rating': $scope.post.rating
      'product_id': product.id

    $http.post("/products/#{product.id}/review/new",$scope.review).success((data) ->
      if data.status == 'duplicate'
        $scope.duplicate_status = true

      if data.status == 'success'
        $scope.success_status = true
        window.location = data.redirect_url
    )

  )

  productTags = (product) ->
    $http.get("/products/#{product.id}/tags").success((data) ->
      $scope.product.tag_list = data.tags
      $scope.tag_list = angular.copy($scope.product.tag_list)
      i = 0
      while i < $scope.tag_list.length
        $scope.tag_list[i].text = $scope.product.tag_list[i].name
        console.log($scope.tag_list[i].text)
        i++
      $scope.tag_list = JSON.stringify($scope.tag_list)
      console.log($scope.tag_list)
    )
    $http.get("/tags/get_all").success((data) ->
      $scope.tags = data.tags
     )

  $scope.deleteTag = (tag,product) ->
    index = $scope.product.tag_list.indexOf(tag)
    $scope.product.tag_list.splice(index, 1);

  $scope.addTag = (tag,product) ->
    addToArray = true
    i = 0
    while i < $scope.product.tag_list.length
      if $scope.product.tag_list[i].name == tag.name
        addToArray = false
      i++
    if addToArray
      $scope.product.tag_list.push tag

  $scope.submitTags = (tags,product) ->
    $http.post("/products/#{product.id}/tags/edit",tags).success((data) ->
      window.location = data.redirect_url
    )


  $scope.searchTags = (tagText,product) ->
    $scope.tag_match = []
    lowercaseSearchText = angular.lowercase($scope.searchTagText)
    x = 0
    if (lowercaseSearchText)
      $scope.new_tag = false
      while x < $scope.tags.length
        value = $scope.tags[x].name.toLowerCase().search(lowercaseSearchText)
        if (value > -1)
          $scope.tag_match.push $scope.tags[x]
          $scope.new_tag = false
        x++
        if lowercaseSearchText !=  $scope.tags[x].name.toLowerCase()
          $scope.new_tag = true
          $scope.newTag = lowercaseSearchText
        else
          $scope.new_tag = false
    else
      $scope.tag_match = []
      $scope.new_tag = false

  $scope.tagging_count = (tag) ->
    $http.get("/tag/tagging_count/#{tag.id}").success((data) ->
      i = 0
      while i < $scope.tags.length
        if $scope.tags[i].id == tag.id
          $scope.tags[i].tag_count = data
        i++
    )

  $scope.addNewTag = (product) ->
    newTagName =
      'name': $scope.newTag
    $http.post("/products/#{product.id}/tags/add",newTagName).success((data) ->
      if data.status == 'login'
        window.location = data.redirect_url
      productTags(product)
    )

  $scope.showEditTagsBox = () ->
    $scope.editTags = true

  $scope.editProduct = (product) ->
    window.location = "/product/#{product.id}/edit"

  $scope.checkLogin = (product) ->
    $http.get("/user/check_login").success((data) ->
      if data.status == 'login'
        window.location = data.redirect_url
      else
        window.location = "/product/#{product.id}/edit"
    )
]
