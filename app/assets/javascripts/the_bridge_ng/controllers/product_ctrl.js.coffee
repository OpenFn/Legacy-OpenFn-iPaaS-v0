@controllerModule.controller 'ProductController', ['$scope', '$location', '$modal', '$http', '$routeParams', '$timeout', ($scope, $location, $modal, $http, $routeParams, $timeout) ->
  $scope.product = {}
  $scope.searchText = ""
  $scope.searchTagText = ""
  $scope.editTags = false
  $scope.added_tags = []
  $scope.tags_added = []
  $scope.deleted_tags = []
  $scope.tags_deleted = []
  $scope.loggedIn = false
  id = $routeParams.id

  if id != undefined
    $http.get('/products/' + $routeParams.id + '.json').success((data) ->
      $scope.product = data
      productTags($scope.product)
      $scope.product.reviews_count = $scope.product.reviews.length
      $scope.productRating($scope.product)
      $scope.tabs = [
        { title:'Description', content: $scope.product.detailed_description },
        { title:'Costs', content: $scope.product.costs, disabled: true },
        { title:'Tech Specs', content: $scope.product.tech_specs, disabled: true },
        { title:'Resources', content: $scope.product.resources, disabled: true }
      ];
      
    )


  $scope.checkVote = (review) ->
    console.log(review)
    $http.get('/review/'+review.id+'/check_vote.json').success (data) ->
      review.voted = data

  $scope.changeVoteFor = (product) ->
    url = $location.url()
    $http.get("/user/check_login?redirect=#{url}").success((data) ->
      if data.status == 'login'
        $scope.showModal()
      else
        $http.get("/products/#{product.id}/vote")
          .success (data) ->
            angular.extend(product,data)
        
          .error (data, status, headers, config) ->
            window.location="/login" if status == 401
      )

  $scope.changeReviewFor = (product) ->
    $http.get("/products/#{product.id}/review")
      .success (data) ->
        angular.extend(product,data)

      .error (data, status, headers, config) ->
        $scope.showModal() if status == 401
        # console.log arguments

  $scope.searchAgain = () ->
    $location.path('/marketplace/search/' + $scope.searchText)

  $scope.productRating = (product) ->
    $http.get("/product/#{product.id}/rating").success((data) ->
      $scope.product.rating = data
  )

      #The else is used so that the review modal is hidden if the user is not logged in
      #Todo: need to call the "write a review" modal here, rather than in the view
  $scope.addReview = (path) ->
      url = if path? then path else $location.url() 

      $http.get("/user/check_login?redirect=#{url}").success((data) ->
        if data.status == 'login'
          $scope.showModal()
        else
          $scope.loggedIn = true
      )


  $scope.vote = (review, up_or_down) ->
    $scope.checkLogin()
    update_vote = false
    create_vote = false
    if up_or_down && (review.voted == -1)
      review.review_score = review.review_score + 2
      review.voted = 1
      update_vote = true
    else if up_or_down && (review.voted == 0)
      review.review_score = review.review_score + 1
      review.voted = 1
      create_vote = true
    else if !up_or_down && (review.voted == 1)
      review.review_score = review.review_score - 2
      review.voted = -1
      update_vote = true
    else if !up_or_down && (review.voted == 0)
      review.review_score = review.review_score - 1
      review.voted = -1
      create_vote = true
    if update_vote || create_vote
      $http.get('review/vote/'+review.id, {params: {vote: review.voted, update: update_vote, create: create_vote}})


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

  

  $star_rating = $('.star-rating .fa')

  SetRatingStar = ->
    $star_rating.each ->
      if parseInt($star_rating.siblings('input.rating-value').val()) >= parseInt($(this).data('rating'))
        $(this).removeClass('fa-star-o').addClass('fa-star')
      else
        $(this).removeClass('fa-star').addClass('fa-star-o')

  $star_rating.on 'click', ->
      $star_rating.siblings('input.rating-value').val $(this).data('rating')
      SetRatingStar()

  SetRatingStar()


  productTags = (product) ->
    $http.get("/products/#{product.id}/tags").success((data) ->
      $scope.product.deep_tag_list = data.tags
    )


    $http.get("/tags/get_all").success((data) ->
      $scope.tags = data.tags
     )

  $scope.deleteTag = (tag,product) ->
    index = $scope.product.deep_tag_list.indexOf(tag)
    $scope.product.deep_tag_list.splice(index, 1);
    i = 0
    addToArray = true
    while i < $scope.added_tags.length
      if $scope.added_tags[i].name == tag.name
        addToArray = false
      i++
    if addToArray
      $scope.deleted_tags.push tag
    $scope.tags_deleted = JSON.stringify($scope.deleted_tags)

  $scope.addTag = (tag,product) ->
    addToArray = true
    i = 0
    while i < $scope.product.deep_tag_list.length
      if $scope.product.deep_tag_list[i].name == tag.name
        addToArray = false
      i++
    if addToArray
      $scope.product.deep_tag_list.push tag
      $scope.added_tags.push tag
    $scope.tags_added = JSON.stringify($scope.added_tags)

  $scope.searchTags = (tagText,product) ->
    $scope.tag_match = []
    lowercaseSearchText = angular.lowercase($scope.searchTagText)
    x = 0
    if (lowercaseSearchText)
      $scope.new_tag = false
      while x < $scope.tags.length
        value = $scope.tags[x].name.toLowerCase().search(lowercaseSearchText)
        if (value > -1)
          i = 0
          unique = true
          while i < $scope.product.deep_tag_list.length
            if $scope.tags[x].name == $scope.product.deep_tag_list[i].name
              unique = false
            i++
          if unique
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


  $scope.addNewTag = (product) ->
    newTagName =
      'name': $scope.newTag
    $http.post("/products/#{product.id}/tags/add",newTagName).success((data) ->
      if data.status == 'login'
        $scope.showModal()
      productTags(product)
    )

  $scope.showEditTagsBox = () ->
    $http.get("/user/check_login").success((data) ->
      if data.status == 'login'
        $scope.showModal()
      else
        $scope.editTags = true
    )


# TODO: Eventually, we will want to turn showModal and checkLogin into services
  $scope.showModal = () ->
    modalInstance = $modal.open
      templateUrl: 'modalTemplate.html',
      controller: 'ModalController'


  $scope.checkLogin = (path) ->
    redirect = if path? then true else false
    url = if path? then path else $location.url()
    $http.get("/user/check_login?redirect=#{url}").success((data) ->
      if data.status == 'login'
        $scope.showModal()
      else
        if redirect
          window.location = url
        else
          $scope.loggedIn = true
        )

  $scope.editProduct = (product) ->
    url = "/product/#{product.id}/edit"
    $scope.checkLogin(url)

  $scope.updateProduct = (product) ->
    productEdit =
      'id': product.id
      'name': product.name
      'email': product.email
      'website': product.website
      'twitter': product.twitter
      'provider': product.provider
      'description': product.description
      'detailed_description': product.detailed_description
      'tech_specs': product.tech_specs
      'costs': product.costs
      'resources': product.resources
      'logo_url': product.logo_url

    $http.post("/admin/products/#{product.id}/tags/add",$scope.tags_added).success((data) ->
    )

    $http.post("/admin/products/#{product.id}/tags/delete",$scope.tags_deleted).success((data) ->
    )

    $http.post("/products/#{product.id}/admin_edit",productEdit).success((data) ->
      window.location = "/product/#{product.id}"
    )

  $scope.newProduct = ()->
    $http.post("/products/admin_new", $scope.product).success((data) ->
      window.location = "/marketplace"
    )

]
