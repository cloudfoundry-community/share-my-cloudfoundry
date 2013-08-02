---
layout: home
title: Share my Cloud Foundry
---

### Introduction

You've deployed Cloud Foundry (no? [follow this tutorial](https://github.com/cloudfoundry-community/bosh-cloudfoundry/tree/master/tutorials)) and now you want to create user accounts. Stop. Don't do it. Let everyone create their own account.

Run this app on your Cloud Foundry and email out the URL. In minutes everyone will create their own account, be educated on how to get started, logged in and deploying applications.

You become the quiet hero. You saved lives and you created less work for yourself. People can look after themselves.

You can enable anyone - staff, contractors or friends - to create accounts with just their email address, integrate with your internal OAuth provider, or integrate with a public OAuth provider (such as Github) to verify their humanity and their email address.

### Deployment

{% highlight bash %}
$ git clone https://github.com/cloudfoundry-community/share-my-cloudfoundry.git
$ cd share-my-cloudfoundry
$ bundle

$ cf target api.internalcf.mycompany.com
$ cf login admin
Password> *******

$ cf push share-my-cloudfoundry --no-start
Domain> start.internalcf.mycompany.com
$ bundle exec cf setup-sharing
Transferring your admin credentials to application...
Deploying...
{% endhighlight %}