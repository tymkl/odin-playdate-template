package main

import "core:c"
import "core:mem"
import "pd"

playdate_allocator_proc :: proc(
    allocator_data: rawptr,
    mode: mem.Allocator_Mode,
    size, alignment: int,
    old_memory: rawptr,
    old_size: int,
    location := #caller_location,
) -> ([]byte, mem.Allocator_Error) {
    pd := (^pd.PlaydateAPI)(allocator_data)
    if pd == nil || pd.system == nil || pd.system.realloc == nil {
        return nil, .Invalid_Argument
    }

    switch mode {
    case .Alloc:
        ptr := pd.system.realloc(nil, c.size_t(size))
        if ptr == nil && size > 0 do return nil, .Out_Of_Memory
        result := mem.byte_slice(ptr, size)
        mem.zero_slice(result)
        return result, .None

    case .Free:
        pd.system.realloc(old_memory, 0)
        return nil, .None

    case .Resize:
        ptr := pd.system.realloc(old_memory, c.size_t(size))
        if ptr == nil && size > 0 do return nil, .Out_Of_Memory
        result := mem.byte_slice(ptr, size)
        if size > old_size {
            mem.zero_slice(result[old_size:])
        }
        return result, .None

    case .Alloc_Non_Zeroed:
        ptr := pd.system.realloc(nil, c.size_t(size))
        if ptr == nil && size > 0 do return nil, .Out_Of_Memory
        return mem.byte_slice(ptr, size), .None

    case .Resize_Non_Zeroed:
        ptr := pd.system.realloc(old_memory, c.size_t(size))
        if ptr == nil && size > 0 do return nil, .Out_Of_Memory
        return mem.byte_slice(ptr, size), .None

    case .Query_Features:
        set := (^mem.Allocator_Mode_Set)(old_memory)
        if set != nil {
            set^ = {.Alloc, .Alloc_Non_Zeroed, .Free, .Resize, .Resize_Non_Zeroed, .Query_Features}
        }
        return nil, .None

    case .Free_All, .Query_Info:
        return nil, .Mode_Not_Implemented
    }
    return nil, .Mode_Not_Implemented
}

playdate_allocator :: proc(api: ^pd.PlaydateAPI) -> mem.Allocator {
    return mem.Allocator{
        procedure = playdate_allocator_proc,
        data      = api,
    }
}
