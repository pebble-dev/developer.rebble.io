---
title: Create Your Own Api With Kimono
author: alex
tags:
- Beautiful Code
---

We'd like to share with you a blog post written by our friends at KimonoLabs.
Their service allows you to build a JSON API from any website. In this guest-
post, they show you how to create a stocker tracker watchapp in less than 10
minutes! This was originally posted here (http://blog.kimonolabs.com/).




###Step 1 - Create a Kimono API to get the data



If you haven’t done so already, sign up for a free account at KimonoLabs. Once
you've signed up, drag the kimonify bookmarklet onto your browser's bookmarks
bar: (http://www.kimonolabs.com/signup)

   ![1](/images/blog/kimono1.png)

First we need to get the data that powers our app, which is simple and painless
with Kimono. Lets head over to CNN Money to get some data.
(http://money.cnn.com/data/markets/)

   ![2](/images/blog/kimono2.png)
   
   Launch kimono by clicking on the kimono bookmarklet. The kimono toolbar will
   appear at the top of the page, making data selectable. Let’s extract the
   stock tickers, names, stock prices, and the % change for the top 5 stocks.
   Click on the data you want and add new properties by clicking the grey “+”
   (e.g., stock price).

   ![3](/images/blog/kimono3.png)
   ![4](/images/blog/kimono4.png)
   ![5](/images/blog/kimono5.png)
   
Click on the data model view (stacked bar icon in the top right) to see how your
data is organized and name each property.

   ![6](/images/blog/kimono6.png)
   
Then click on the data preview view (inverse carrot icon to the right of the
data model icon) to preview your data in json or csv.

   ![7](/images/blog/kimono7.png)

This looks good, so click DONE, name your API, set a schedule and kimono will
create an API.

   ![8](/images/blog/kimono8.png)

   ![9](/images/blog/kimono9.png)
   
Click the link to see detail on your new API.

   ![10](/images/blog/kimono10.png)
   
Click on the JSON endpoint to check out the data.

   ![11](/images/blog/kimono11.png)
   
Let's copy the url to this JSON endpoint. Go ahead and open up another tab for
the next steps.

###Step 2 - CloudPebble

If you haven’t done so already, sign up for a Pebble developer account:
(https://auth.getpebble.com//users/sign_up). Also make sure you have the Pebble
app installed on your phone, your Pebble smart watch is paired with your phone,
and Pebble developer mode is enabled. (/2
/getting-started/developer-connection/)




Set up a new project in the CloudPebble development environment
({{site.links.cloudpebble}}), making sure that the Project Type is set to
SimplyJs. This will allow us to use JavaScript to create our Pebble app, writing
code in the CloudPebble in-browser IDE!

   ![12](/images/blog/kimono12.png)
   ![13](/images/blog/kimono13.png)
  
  Go ahead and click the the automatically created app.js file. Delete its
   contents and paste the following code into the file, replacing <
   your_kimono_api_url  > with the url we got from our Kimono API:
   ![14](/images/blog/cpkimono.png)
   
   
Here is the code:


   
```c
var getData = function(){
  console.log("getting data");
  
  ajax({
    url: '<your_kimono_api_url>', 
    type: 'json'
  },
  function(data) {
    
    console.log("gotdata: " + JSON.stringify(data));
    var output = '';
    data.results.collection1.forEach(function(element, index){

      //get  the company title - limited to 10 character
      var companyTitle = element.name;
      if(companyTitle.length < 10) companyTitle = companyTitle.substring(0, 10) + '...';
      //append this to the output
      output += companyTitle +'\n' + '$' + element.price+'\n' + element.change+'\n\n';
    });
    simply.setText({body: output});
  },
    function(error) {
      console.log("Got error: " + JSON.stringify(error));
      simply.title(error.status);
      simply.body(error.error);
    }
);
};

console.log("Loading...");

// Initialize the screen
simply.scrollable(true);
simply.title("Loading...");

// Start getting the data
getData();
```

Lets go through a quick explanation of the code.

```c
ajax({
    url: '<your_kimono_api_url>', 
    type: 'json'
  },
  function(data) {
    
    console.log("gotdata: " + JSON.stringify(data));
    var output = '';
    data.results.collection1.forEach(function(element, index){

      //get  the company title - limited to 10 character
      var companyTitle = element.name;
      if(companyTitle.length < 10) companyTitle = companyTitle.substring(0, 10) + '...';
      //append this to the output
      output += companyTitle +'\n' + '$' + element.price+'\n' + element.change+'\n\n';

  });


```

This bit of code makes an ajax request to our Kimono api, getting a JSON
response. Once we receive that data, we go ahead and process it in the callback.

Looping through each company, we pull out the company name (shortened to 10
characters), the company’s current stock price, and the % change in the
company’s stock price.

```c
simply.setText({body: output});
```

All this data is then outputted to the screen on our pebble.

This functionality is all wrapped up in a function called getData.

```c
simply.scrollable(true);
```
This sets a property to make the app scrollable. 


```c
getData();

```
Then we simply call our getData function. 

   ![15](/images/blog/kimono15.png)
   
   ![16](/images/blog/kimono16.png)
   
   Hit play and watch your app run.
   
   ![17](/images/blog/kimono17.jpeg)
   
   And thats all folks, in just a few minutes we were able to create a stock
   tracker for Pebble with live data!
