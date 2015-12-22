#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <arpa/inet.h>

typedef unsigned char u8;

/*
 * 输入参数已经转换成了大端(网络序)，再处理
 */
int convertValue(u8 *buf, int len, u8 **result) {
    int index = 0;
    *result = malloc(2*len);
    if (*result == NULL) {
        perror("malloc()");
        return -1;
    }

    u8 *values = *result;
    memset(values, 0, 2*len);

    for (int i = 0; i < len; i++) {
        if ((buf[i] == 0x7E) || (buf[i] == 0xAC) || (buf[i] == 0x1B)) {
            values[index++] = 0x1B;
            values[index++] = buf[i] ^ 0x1B;
        } else {
            values[index++] = buf[i];
        }
    }

    return index;
}

u8 getChecksum(u8 *buf, int len) {
    u8 checksum = 0;

    for (int i = 0; i < len; i++) {
        checksum ^= buf[i];
    }

    return checksum;
}

void printFrame(u8 *buf, int len) {
    printf("<<Frame>>\n");
    for (int i = 0; i < len; i++) {
        if ((i % 16) == 0) {
            putchar('\n');
        }
        printf("  0x%02x", buf[i]);
    }

    printf("\n\n Finish!\n");
}

int main(void) {
    unsigned char frameHead = 0x7e;
    unsigned char frameTail = 0xac;

    unsigned char cmd = 11;
    unsigned char mode = 1;
    unsigned char ADNumber = 1;
    int originADValue = 0x7e12ac1b;
    int originWeight = 80;
    unsigned char checksum = 0;


    // originADValue -> ADValue
    // 1. 主机序转网络序
    originADValue = htonl(originADValue);
    // 2. 转义特殊字符
    unsigned char *ADValue;
    int ADValueLen = 0;
    ADValueLen = convertValue((unsigned char *)&originADValue, sizeof(int), &ADValue);
    if (ADValueLen < 0) {
        fprintf(stderr, "Error: Convert value error!\n");
        return -1;
    }
    printf(">> ADValueLen:%d\n", ADValueLen); 

    originWeight = htonl(originWeight);
    unsigned char *weight;
    int weightLen = 0;
    weightLen = convertValue((unsigned char *)&originWeight, sizeof(int), &weight);
    if (weightLen < 0) {
        fprintf(stderr, "Error: Convert value error!\n");
        return -1;
    }

    printf(">> weightLen:%d\n", weightLen);
    printf("Convert OK!\n"); 
    
    int frameLen = 1+1+1+1+ADValueLen+weightLen+1+1;
    printf("frameLen:%d\n", frameLen);
    unsigned char *frame = malloc(frameLen);
    if (frame == NULL) {
        perror("malloc()");
        return -1;
    }

    int index = 0;
    frame[index++] = frameHead;
    frame[index++] = cmd;
    frame[index++] = mode;
    frame[index++] = ADNumber;

    printf("** index = %d\n", index);
    memcpy(&frame[index], ADValue, ADValueLen);
    index += ADValueLen;

    printf("** index = %d\n", index);
    memcpy(&frame[index], weight, weightLen);
    index += weightLen;
    
    printf("** index = %d\n", index);
    checksum = getChecksum(frame-1, frameLen-2);

    frame[index++] = checksum;

    frame[index++] = frameTail;

    printf("index: %d\t frame len: %d\n", index, frameLen);

    printFrame(frame, frameLen);

    free(ADValue);
    free(weight);
    return 0;
}
