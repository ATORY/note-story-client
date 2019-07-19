String allViewQuery = """
  query AllViewQuery(\$after: String, \$first: Int) {
    allViewer {
      stories(after: \$after, first: \$first) {
        edges {
          node {
            id
            title
            intro
            tags
            publishTime
            clientURL
            publisher {
              id
              email
              nickname
              avator
              banner
            }
          }
        }
        pageInfo {
          hasNextPage
        }
      }
    }
  }
""";

String userInfoQuery = """
  query userInfoQuery(\$token: String!) {
    userInfo(token: \$token) {
      id
      email
      nickname
      avator
      banner
    }
  }
""";

String userProfileQuery = """
  query userProfileQuery(\$openId: String!, \$after: String, \$first: Int) {
    userProfile(openId: \$openId) {
      id
      nickname
      avator
      banner
      stories: publishedStories(after: \$after, first: \$first) {
        edges {
          node {
            id
            title
            intro
            publishTime
            tags
          }
        }
        pageInfo {
          hasNextPage
        }
      }
    }
  }
""";

String userPublishQuery = """
  query PublishQuery(\$token: String!, \$first: Int, \$after: String) {
    info: userInfo(token: \$token) {
      ...Publish_info @arguments(first: \$first, after: \$after, token: \$token)
    }
  }
""";

