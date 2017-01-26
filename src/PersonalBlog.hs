{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
module PersonalBlog
    ( routes
    ) where

import Web.Scotty
import Data.Aeson (FromJSON, ToJSON, encode, decode)
import GHC.Generics

routes :: IO ()
routes = do
    putStrLn "Starting server..."
    scotty 3000 $ do
        get "/posts" $ do
            json getAllPosts
        get "/posts/:id" $ do
            id <- param "id"
            json (filter (matchesId id) getAllPosts)
        get "/" $ index

index :: ActionM ()
index = do
    html "Index"


data Post = Post { postId :: Int, title :: String, content :: String } deriving (Show, Generic)

instance ToJSON Post
instance FromJSON Post

post1 :: Post
post1 = Post { postId = 1, title = "Title1", content = "Content" }

post2 :: Post
post2 = Post { postId = 2, title = "Title2", content = "Content" }

getAllPosts :: [Post]
getAllPosts = [post1, post2]

matchesId :: Int -> Post -> Bool
matchesId id post = postId post == id
