# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#

Book.create(
  title:'Kubernetes Up & Running',
  description: """
    In just five years, Kubernetes has radically changed the way developers and ops personnel build, deploy, and maintain applications in the cloud.
    With this book's updated third edition, you'll learn how this popular container orchestrator can help your company achieve new levels of velocity, agility, reliability, and efficiency--whether you're new to distributed systems or have been deploying cloud native apps for some time.
    Brendan Burns, Joe Beda, Kelsey Hightower, and Lachlan Evenson--who have worked on Kubernetes at Google and beyond--explain how this system fits into the life cycle of a distributed application.
    Software developers, engineers, and architects will learn ways to use tools and APIs to automate scalable distributed systems for online services, machine learning applications, or even a cluster of Raspberry Pi computers.
    This guide shows you how to: Create a simple cluster to learn how Kubernetes works Dive into the details of deploying an application using Kubernetes Learn specialized objects in Kubernetes, such as DaemonSets, jobs, ConfigMaps, and secrets Explore deployments that tie together the lifecycle of a complete application Get practical examples of how to develop and deploy real-world applications in Kubernetes
  """,
  cover_url: 'https://m.media-amazon.com/images/I/81fH7yJ8rsL._SL1500_.jpg',
  price: '54,72'
)

Book.create(
  title: 'Creating Software with Modern Diagramming Techniques',
  description: """
    Diagrams communicate relationships more directly and clearly than words ever can.
    Using only text-based markup, create meaningful and attractive diagrams to document your domain, visualize user flows, reveal system architecture at any desired level, or refactor your code.
    With the tools and techniques this book will give you, you'll create a wide variety of diagrams in minutes, share them with others, and revise and update them immediately on the basis of feedback.
  """,
  cover_url: 'https://m.media-amazon.com/images/I/81Qu4QCh0PL._SL1500_.jpg',
  price: '27,38'
)

Book.create(
  title:"Programming Phoenix Liveview",
  description: """
    The days of the traditional request-response web application are long gone, but you don't have to wade through oceans of JavaScript to build the interactive applications today's users crave.
    The innovative Phoenix LiveView library empowers you to build applications that are fast and highly interactive, without sacrificing reliability. This definitive guide to LiveView isn't a reference manual.
    Learn to think in LiveView. Write your code layer by layer, the way the experts do.
    Explore techniques with experienced teachers to get the best possible performance.
  """,
  cover_url: 'https://m.media-amazon.com/images/I/81KtOhfPCjL._SL1500_.jpg',
  price: '48,62'
)
