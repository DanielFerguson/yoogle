# Yoogle

Search videos by their captions, and generate shareable GIFs and memes instantly.

## What

Yoogle is a pet project of mine, and has been something that I have wanted to build for my friend circle since 2016. We all have very similar tastes in humour and YouTube channels (echo chamber, anyone?), and as a result we frequently quote old videos to eachother.

I always wanted a way to search for these clips by quote, and have a meme or GIF (I refuse to pronouce it as jif) generated from it.

This project is finally going to realise those abilities for us.

## Why

I have a couple of goals for this project...

### Get better at Terraform

I am using TF more and more in my development life these days. I'm really enjoying having the ability to share, scrutenise and re-use infrastructure easily through code. I'm not a fan of CloudFormation, and really enjoy the ability to spin up infra from multiple providers in the same config set.

### A brain-break from my [day job](https://www.communitilabs.com)

If you're not aware, I am a co-founder of Communiti Labs; an AI-powered data analytics company. Working on the challenges there is mentally stimulating, to say the least. However, I have been longing for a bit of a break on my weekends. This is a nice way to still flex my development muscles, and experiment with some tools and techniques that I can take back into Communiti Labs.

By the way, if you're interested in Communiti Labs, [ask me about it](https://linkedin.com/in/danferg)!

### Try out some new tech

While I am experienced with most of the technologies that I plan on using for this project, I may have not used this style. For instance, we use Clerk as our authentication platform for Communiti Labs, but mostly through server-side authentication. I'm excited to try using it for FE auth too.

I'm a massive Postgres fanboy, though I have never used the Neon DB platform; and with [the latest changes from PlanetScale](https://planetscale.com/blog/planetscale-forever), there's never been a better time to look for alternatives that offer a free tier.

And if you have any experience with Elysia, pnpm workspaces or Keysley... feel free to give me some feedback. This should be fun.

### I just want it

Sometimes you don't need any more reason other than no one else has built it yet, and I can, so I must.

## How

I wanted to keep myself on-task by giving this project some pretty simple tenets and milestones. I also wanted to set out an overview of the technologies used in the project, and some justification for the tools.

### Goals

(Most) Technological choices for this projet have been made with these goals in mind...

#### 1. Scale to zero (cost)

This is a pet project, and is never going to make money. I have made SaaS application like [Airproxy](https://airproxy.app/) (a dead-simple proxy for Airtable APIs) which I am fine with spending dosh on services. This is not the same, and should incur minimal, if any, on-going costs.

#### 2. Scale to 'n'

Here's hoping that this is useful for you and others! Both for the peace of mind, for good practise and just because I like too, I want to make sure it scales (if need be).

#### 3. Safety

I want to detect errors in the connection between the backend and the frontend as fast as possible; ideally before it's shipped. I'd rather not use a tool like Sentry to monitor errors, as I want to keep time on this project as minimal as possible.

#### 4. Simplicity

As aforementioned, I want to keep this fairly simple. While some tech choices are made for learning opportunities, most will be because it's tested, tried and true (and cheap!).

### Technologies

#### Infrastructure

| Purpose         | Technology      | Justification                                                          |
| --------------- | --------------- | ---------------------------------------------------------------------- |
| File storage    | S3              | Come on, what else? (yes, CF is decent)                                |
| Website hosting | S3              | Dirt cheap.                                                            |
| Functions       | Lambda          | Scales to zero, and is dead simple.                                    |
| Authentication  | Clerk           | It's awesome, and free!                                                |
| DNS             | Cloudflare      | I already use it, and love it.                                         |
| IaC             | Terraform       | I want to get better at it for other projects.                         |
| Database        | Neon DB         | Cheap, and Postgres!                                                   |
| Embedding Model | Unsure          | Still investigating the most cost efficient (read: 'cheap') tool here. |
| Repo tooling    | PNPM Workspaces | I want to be able to share types between frontend & backend            |

#### Other Tools

- **Vite & React:** Keep It Simple Stupid.
- **Tailwind:** Refer to the previous point.
- **Keysley:** I love Prisma and Drizzle, but haven't had any good reason to try other libraries in the space. I've heard good things about Keysley, and it's simplicity. I come from a background of using Laravel's Eloquent ORM, and I miss its migration workflow. Keysley's looks very similar.
- **Elysia:** I recently saw someone mention Elysia on Hackernews, and have been looking for an excuse to use it somewhere. I want to setup a monorepo so that we can share types between the front-end and back-end for typesafe APIs without using tRPC\*. It's also wicked fast. 🏎️
- **Shadcn UI:** It's gorgeous. Enough said.

\*I've got nothing agains't tRPC. On the contrary, I love it when I'm not using Next JS' Server Actions. I wanted to try this kind of monorepo/project configuration.

### Solutions Architecture

![Yoogle solutions architecture design](https://github.com/danielferguson/yoogle/blob/main/assets/yoogle-solutions-architecture-design.png?raw=true)

# Resources

- [Serverless Applications with AWS Lambda and API Gateway](https://registry.terraform.io/providers/hashicorp/aws/2.34.0/docs/guides/serverless-with-aws-lambda-and-api-gateway#allowing-api-gateway-to-access-lambda)
- [Packaging Python requirements as an AWS Lambda Layer with Terraform](https://cj-hewett.medium.com/packaging-python-requirements-as-an-aws-lambda-layer-with-terraform-188f76db4e96)
- [elysia-clerk](https://github.com/wobsoriano/elysia-clerk)
- [elysia](https://elysiajs.com/)

# Roadmap

## User Stories

- [ ] I am able to search videos by captions and get results on a per-sentence level.
- [ ] I am shown a preview of the video at that timestamp for my results.
- [ ] I am able to log into the website.
- [ ] When authenticated, I am able to suggest videos to be transcribed by submitting YouTube URLs.
- [ ] When authenticated, I can see the videos that I previously submitted and their transcription status.

## Tasks

2024-04-25

- [x] Create frontend (`/apps/web`) project
- [x] Create basic infrastructure project
- [x] Setup `yoogle-frontend` S3 bucket
- [x] Setup GitHub Actions to build the `web` app and upload to `yoogle-frontend` bucket
- [x] Setup Cloudflare DNS to point `www.yoogle.app` to the `yoogle-frontend` bucket

2024-0X-XX

- [ ] Setup AWS billing alerts for this project (via tag filtering)
- [ ] Modularise the `/infra` dir
- [ ] Setup database
- [ ] Setup & configure Keysley
- [ ] Create CLI script to process YouTube videos
- [ ] Setup web components (shadcn, tailwind)
- [ ] Create search UI
- [ ] Plan the necessary API routes

Backlog

- [ ] Scope `s3_user` iam users s3 permissions
