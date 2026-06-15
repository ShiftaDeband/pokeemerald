ENTRY(Start)

gNumMusicPlayers = 4;
gMaxLines = 0;

MEMORY
{
    EWRAM (rwx) : ORIGIN = 0x2000000, LENGTH = 256K
    IWRAM (rwx) : ORIGIN = 0x3000000, LENGTH = 32K
    ROM    (rx) : ORIGIN = 0x8000000, LENGTH = 32M
}

SECTIONS {

    ewram 0x2000000 (NOLOAD) :
    ALIGN(4)
    {
        gHeap = .;

        INCLUDE "sym_ewram_rev10.ld"
        src/*.o(ewram_data);

        *libc.a:impure.o(.data);
        *libc.a:locale.o(.data);
        *libc.a:mallocr.o(.data);
    } > EWRAM

    iwram 0x3000000 (NOLOAD) :
    ALIGN(4)
    {
        /* .bss starts at 0x3000000 */
        INCLUDE "sym_bss_rev10.ld"
        src/*.o(.bss);
        data/*.o(.bss);

        /* .bss.code starts at 0x30028E0 */
        src/m4a.o(.bss.code);

        /* COMMON starts at 0x30030E0 */
        INCLUDE "sym_common_rev10.ld"
        src/*.o(COMMON);

        *libc.a:sbrkr.o(COMMON);
        end = .;
    } > IWRAM

    /* BEGIN ROM DATA */
    . = 0x8000000;

    .text :
    ALIGN(4)
    {
        src/rom_header.o(.text);
        src/rom_header_gf.o(.text.*);
        src/crt0.o(.text);
        src/*.o(.text);
        src/*.o(.text.*);
        libagbsyscall/libagbsyscall.a:*.o(.text);
        *libgcc.a:*.o(.text);
        *libc.a:*.o(.text);
        *libnosys.a:*.o(.text);
    } > ROM =0

    script_data :
    ALIGN(4)
    {
        data/event_scripts.o(script_data);
        data/battle_anim_scripts.o(script_data);
        data/battle_scripts_1.o(script_data);
        data/field_effect_scripts.o(script_data);
        data/battle_scripts_2.o(script_data);
        data/battle_ai_scripts.o(script_data);
        data/mystery_event_script_cmd_table.o(script_data);
    } > ROM =0

    .rodata :
    SUBALIGN(4)
    {
        src/*.o(.rodata);
        src/*.o(.rodata.str1.4);
        data/*.o(.rodata);
        data/*.o(.rodata.str1.4);
        sound/*.o(.rodata);
        sound/*.o(.rodata.str1.4);
        libagbsyscall/libagbsyscall.a:*.o(.rodata);
        *libgcc.a:*.o(.rodata);
        *libc.a:*.o(.rodata);
        *libnosys.a:*.o(.rodata);
    } > ROM =0

    /* The alignment of the different sections is important, do not change it! */
    .data :
    SUBALIGN(4)
    {
        src/*.o(.data);
        data/*.o(.data);
        sound/*.o(.data);
        *libgcc.a:*.o(.data);
        *libc.a:*.o(.data);
        *libnosys.a:*.o(.data);
    } > ROM =0

    /* ARM MWare SDK's libagbsyscall uses .text section, no .iwram section.
       Need to place the .iwram section after the .rodata section so addresses
       don't change. */
    .iwram :
    SUBALIGN(4)
    {
        src/*.o(iwram);
        data/*.o(iwram);
    } > ROM =0
}
