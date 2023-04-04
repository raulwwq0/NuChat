# SonarQube with Docker

This repository contains all the necessary files to run SonarQube locally with Docker.

>  **Note:** This repository is intended to be used for development purposes only.

## Pre-requisites

-   Docker
-   Docker Compose

## Usage

The first thing you need to do is install the dependencies (basically, the SonarQube Scanner):

```bash
  npm install
```

Then, you can run the following command to start the SonarQube server:

```bash
  npm run sonar:up
```

You can also run the following command to stop the SonarQube server:

```bash
  npm run sonar:down
```

And you are done! You can now access the SonarQube dashboard at [http://localhost:9000](http://localhost:9000).

## Beginner's Guide

Once you have the SonarQube server running and entered the dashboard, you will need to create a new project. To do so, you can follow the steps below:

1.  Click on the **Create Project Manually** button.
2.  Enter the project name and key, which are normally the same. Copy the key and paste it in the `sonar-scanner.properties` file. Then, click on the **Set Up** button.
3. Click on the **Analyze Project Locally** button.
4. Create a new token by clicking on the **Generate** button. Then, copy the token and paste it in the `sonar-scanner.properties` file.
5. Run the following command inside your project to start the SonarQube scanner:

```bash
  npm run sonar:scan
```

>  **Note:** Is also possible to install the SonarQube Scanner globally and run the command `sonar-scanner` instead of `npm run sonar:scan`. Using that approach, you will no longer need to implement this repository in your project. Simply follow this guide and run the command `sonar-scanner` inside your project and it will work.

6.  Go back to the SonarQube dashboard and click on the **Refresh** button. You should see your project there.

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
