# NuChat

NuChat is an instant messaging app (similar to WhatsApp) built with [Nuxt 3](https://nuxt.com/) and [Supabase](https://supabase.com/).

---

## Low-Fi Prototypes

### Landing Page

![Landing page low-fi prototype](./docs/images/prototypes/landing-low.jpeg)

### Sign In Form

![Sign In Form low-fi prototype](./docs/images/prototypes/sign-in-low.jpeg)



> _Waiting for approval_ <br><br>
(This section will be erased when I get an answer to the following proposal)<br><br>
Thanks to Supabase Auth system I can send a mail to the users email address with a link (called **Magic Link**) and they can sign in NuChat without password. More information [here](https://supabase.com/docs/guides/auth/auth-magic-link). <br><br>
My plan is to not store any password, so you will be able to enter the app with a Magic Link or with [other provider](https://supabase.com/docs/guides/auth/social-login). Is this approach suitable for this proyect or should I remain with an user/password based auth system?

### Main View

![Main View low-fi prototype](./docs/images/prototypes/main-view-low.jpeg)

### Profile

![Profile low-fi prototype](./docs/images/prototypes/profile-low.jpeg)

### Admin Panel

![Admin panel low-fi prototype](./docs/images/prototypes/admin-panel-low.jpeg)

---

## Installation

This project uses [Turborepo](https://turbo.build/repo), so to install all dependencies from every part of the project you just need to run the following command:

```bash
npm install # or "npm i"
```

After that, you just need to run the next command to start the whole app:

```bash
npm run dev
```

> **Note**: Since Turborepo works with _npm monorepos_, running the previous commands in the project root will execute the exact same command in each folders inside `apps` directory (sub-project). You can also run the command you want inside each sub-project to avoid executing them globally.

---

## Usage

`WIP`: Since the app might change from the [low-fi prototypes](#low-fi-prototypes) this section will be fullfilled when the app is going to be finished.

---

## Port List

These are the ports where each sub-project is exposed:

- Web (Nuxt): `3000`
- Supabase (Studio): `3100`
- Supabase (API): `3200`
- SonarQube: `3300`